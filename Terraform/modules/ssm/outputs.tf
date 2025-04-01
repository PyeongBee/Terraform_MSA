output "ssm_role_name" {
  value = aws_iam_role.ec2_ssm_role.name
}

output "ssm_profile_name" {
  value = aws_iam_instance_profile.ssm_profile.name
}
