output "ecr_url" {
  value       = aws_ecr_repository.registry.repository_url
  description = "The url of the container registry."
  sensitive   = false # Being explicit here. Default value is also false. This flag will help to supress values in CLI output
}
