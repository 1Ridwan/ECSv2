data "aws_ecr_repository" "ecsv2" {
  name = "ecsv2" # put into variable later
}

data "aws_ecr_image" "app" {
  repository_name = data.aws_ecr_repository.ecsv2.name
  image_tag = "latest"
}