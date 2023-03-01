provider "aws" {
  region = "us-east-1"
}

# Create the ECR repository
resource "aws_ecr_repository" "my_ecr_repo" {
  name = "my-node-app"
}

# Output the repository URL
output "repository_url" {
  value = aws_ecr_repository.my_ecr_repo.repository_url
}
