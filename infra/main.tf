provider "aws" {
  version = "~> 2.23"
  region  = "us-east-1"
}

# data "template_file" "inventory" {
#   template = "${file("./inventory.tpl")}"

#   vars = {
#     public_ip = data.aws_instance.devops_assignment2.public_ip
#   }
# }

# resource "local_file" "save_inventory" {
#   content = data.template_file.inventory.rendered
#   filename = "../ansible/inventory.yml"
  
# }

# data "template_file" "db_config" {
#   template = "${file("./db_conf.tpl")}"

#   vars = {
#     db_user = aws_db_instance.devops_assignment2_db.username
#     db_pw = aws_db_instance.devops_assignment2_db.password
#     db_name = aws_db_instance.devops_assignment2_db.name
#     db_port = aws_db_instance.devops_assignment2_db.port
#     db_host = aws_db_instance.devops_assignment2_db.address
#   }
# }

# resource "local_file" "save_db_config" {
#   content = data.template_file.db_config.rendered
#   filename = "../ansible/conf.toml"
  
# }