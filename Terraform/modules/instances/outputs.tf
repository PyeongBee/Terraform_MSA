output "gitlab_instance" {
  value = aws_instance.gitlab
}

output "jenkins_instance" {
  value = aws_instance.jenkins
}

output "prv_inst_sg_id" {
  value = aws_security_group.prv_inst_sg.id
}
