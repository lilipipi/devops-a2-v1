provider "aws" {
  version = "~> 2.23"
  region  = "us-east-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "developer-key"
  public_key = var.public_key
}


data "template_file" "inventory" {
  template = "${file("./inventory.tpl")}"

  vars = {
    public_ip = data.aws_instance.devops_assignment2.public_ip
  }
}

resource "local_file" "save_inventory" {
  content = data.template_file.inventory.rendered
  filename = "../ansible/inventory.yml"
  
}

data "template_file" "db_config" {
  template = "${file("./db_conf.tpl")}"

  vars = {
    db_user = aws_db_instance.devops_assignment2_db.username
    db_pw = aws_db_instance.devops_assignment2_db.password
    db_name = aws_db_instance.devops_assignment2_db.name
    db_port = aws_db_instance.devops_assignment2_db.port
    db_host = aws_db_instance.devops_assignment2_db.address
  }
}

resource "local_file" "save_db_config" {
  content = data.template_file.db_config.rendered
  filename = "../ansible/conf.toml"
  
}

##############################################

resource "random_string" "tfstatename" {
  length = 6
  special = false
  upper = false
}

resource "aws_s3_bucket" "kops_state" {
  bucket        = "rmit-kops-state-${random_string.tfstatename.result}"
  acl           = "private"
  force_destroy = true
  
  versioning {
    enabled = true
  }

  tags = {
    Name = "kops remote state"
  }
}

resource "aws_ecr_repository" "app" {
  name                 = "app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_s3_bucket" "tfrmstate" {
  bucket        = "rmit-tfstate-${random_string.tfstatename.result}"
  acl           = "private"
  force_destroy = true

  tags = {
    Name = "TF remote state"
  }
}

resource "aws_dynamodb_table" "terraform_statelock" {
  name = "RMIT-locktable-${random_string.tfstatename.result}"
  read_capacity = 20
  write_capacity = 20
  hash_key = "LockID"

  attribute {
      name = "LockID"
      type = "S"
  }
}

output "state_bucket_name" {
  value = aws_s3_bucket.tfrmstate.bucket
}

output "dynamoDb_lock_table_name" {
  value = aws_dynamodb_table.terraform_statelock.name
}

output "ecr_url" {
  value = aws_ecr_repository.app.repository_url
}

output "kops_state_bucket_name" {
  value = aws_s3_bucket.kops_state.bucket
}
