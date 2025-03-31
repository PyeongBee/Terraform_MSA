output "gitlab_instances_id" {
  value = aws_instance.gitlab.id
}

output "gitlab_instances_public_ip" {
  value = aws_instance.gitlab.public_ip
}

output "gitlab_instances_private_ip" {
  value = aws_instance.gitlab.private_ip
}
