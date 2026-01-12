# ECR repo with container images for app - created outside terraform

data "aws_ecr_repository" "images" {
  name = var.ecr_repo_name
}

data "aws_ecr_image" "app-image" {
  repository_name = data.aws_ecr_repository.images.name
  image_tag = "latest"
}

# ----------- ECS resources ----------- #

resource "aws_ecs_cluster" "main" {
  name = "cluster-${var.env_name}"
}

data "aws_iam_role" "ecs_service_role" {
  name = "AWSServiceRoleForECS"
}

resource "aws_ecs_service" "main" {
  name            = "ecs-service-${var.env_name}"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = var.task_count
  launch_type = "FARGATE"

  deployment_controller {
      type = "CODE_DEPLOY"
  }

  load_balancer {
    target_group_arn = var.blue_target_group_arn
    container_name   = "${var.env_name}-url-shortener"
    container_port   = var.container_port
  }

   network_configuration {
    subnets = var.private_subnet_ids
    security_groups = [var.ecs_service_sg_id]
    assign_public_ip = false
   }

    lifecycle {
   ignore_changes = [load_balancer, task_definition]
 }
}

# TODO: pass TABLE_NAME to task definition through vault?
resource "aws_ecs_task_definition" "app_task" {
  family                   = "url-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu_size
  memory                   = var.memory_size

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

container_definitions = jsonencode([
  {
    name      = "${var.env_name}-url-shortener"
    image     = "${data.aws_ecr_repository.images.repository_url}@${data.aws_ecr_image.app-image.image_digest}"
    essential = true

    environment = [
        {
            name = "TABLE_NAME"
            value = "${var.table_name}-${var.env_name}"
        }
    ]

    portMappings = [
      {
        containerPort = var.container_port
        hostPort = var.container_port
        protocol      = "tcp"
      }
    ]

    logConfiguration = {
      logDriver = "awslogs",
      options = {
        awslogs-group         = aws_cloudwatch_log_group.url-shortener.name
        awslogs-region        = var.vpc_region
        awslogs-stream-prefix = "dev-ecs"
      }
    }
  }
])
}

resource "aws_cloudwatch_log_group" "url-shortener" {
  name              = "/ecs/url-shortener/${var.env_name}"
  retention_in_days = 14
}


# iam roles


# resource "aws_iam_role" "ecs_service_role" {
#   name = "ecs-service-role" # add naming convention with dev/staging/prod?

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = "AllowAccessToECSForInfrastructureManagement"
#         Principal = {
#           Service = "ecs.amazonaws.com"
#         }
#       },
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "ecs_service_role_policy" {
#   role       = aws_iam_role.ecs_service_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonECSInfrastructureRolePolicyForLoadBalancers"
# }

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# ECS task role which allows DDB permissions

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess" # limit access to specific table only?
  
}

