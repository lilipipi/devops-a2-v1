# output "instance_public_ip" {
#   value = data.aws_instance.devops_assignment2.public_ip
# }

output "lb_endpoint" {
  value = aws_lb.devops_assignment2.dns_name
}

output "db_endpoint" {
  value = aws_db_instance.devops_assignment2_db.endpoint
}

output "db_user" {
  value = aws_db_instance.devops_assignment2_db.username
}

output "db_pass" {
  value = aws_db_instance.devops_assignment2_db.password
}

output "db_name" {
  value = aws_db_instance.devops_assignment2_db.name
}