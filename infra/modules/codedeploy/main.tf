# -------------- Codedeploy -------------- #

resource "aws_codedeploy_app" "app" {
  compute_platform = "ECS"
  name             = "url-shortener-${var.env_name}"
}

# resource "aws_codedeploy_deployment_config" "canary" {
#   deployment_config_name = "test-deployment-config"
#   compute_platform       = "ECS"

#   traffic_routing_config {
#     type = "TimeBasedLinear"

#     time_based_linear {
#       interval   = 10
#       percentage = 10
#     }
#   }
# }

# iam role for codedeploy

resource "aws_iam_role" "codedeploy_role" {
  name = "ecs-code-deploy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy_role_policy" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

resource "aws_codedeploy_deployment_group" "blue_green" {
  app_name               = aws_codedeploy_app.app.name
  deployment_group_name  = "blue-green-${var.env_name}"
  service_role_arn       = aws_iam_role.codedeploy_role.arn
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

   blue_green_deployment_config {
    deployment_ready_option {
         action_on_timeout = "CONTINUE_DEPLOYMENT"
         wait_time_in_minutes = 0
      }

      terminate_blue_instances_on_deployment_success {
        action = "TERMINATE"
        termination_wait_time_in_minutes = 5
      }
   }

   deployment_style {
      deployment_option = "WITH_TRAFFIC_CONTROL"
      deployment_type = "BLUE_GREEN"
   }

   ecs_service {
    service_name = var.ecs_service_name
    cluster_name = var.ecs_cluster_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.prod_listener_arn] 
      }
      test_traffic_route {
        listener_arns = [var.test_listener_arn] 
      }

      target_group {
        name = var.blue_target_group_name
      }

      target_group {
        name = var.green_target_group_name
      }
    }
  }
}
