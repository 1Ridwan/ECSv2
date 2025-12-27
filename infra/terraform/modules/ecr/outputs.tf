output "ecr_arn" {
    value = data.aws_ecr_repository.ecsv2.arn
}

output "ecr_repo_url" {
    value = data.aws_ecr_repository.ecsv2.repository_url
}

output "ecr_repo_name" {
    value = data.aws_ecr_repository.ecsv2.name
}

output "ecr_image_digest" {
    value = data.aws_ecr_image.app.image_digest
}