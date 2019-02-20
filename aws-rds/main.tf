provider "aws" {
  version = "~> 1.56"
}

terraform {
  backend "s3" {
    bucket  = "sample-terraform-states"
    key     = "rds-server-deployment"
    region  = "ap-northeast-1"
  }
}

resource "aws_db_instance" "db_instance_sample" {
  storage_type                = "${var.storage_type}"
  engine                      = "${var.engine_type}"
  engine_version              = "${var.engine_version}"
  instance_class              = "${var.instance_class}"

  # Note: For free tier, allocated storage must be 20GB.
  allocated_storage           = "${var.allocated_storage_size}"

  identifier                  = "sample-${terraform.workspace}-mysql-db"
  name                        = "${terraform.workspace}"
  username                    = "${var.DB_ADMIN_USERNAME}"
  password                    = "${var.DB_ADMIN_PASSWORD}"
  port                        = "${var.port}"

  parameter_group_name        = "${var.default_param_group_name}"

  deletion_protection         = false

  skip_final_snapshot         = true
  final_snapshot_identifier   = "sample-${terraform.workspace}-${md5(timestamp())}"
  
  backup_retention_period     = "${var.retention_period}"

  publicly_accessible         = true
  apply_immediately           = true
}

# resource "aws_db_instance" "db_instance_environment" {
#   storage_type                = "${var.storage_type}"
#   engine                      = "${var.engine_type}"
#   engine_version              = "${var.engine_version}"
#   instance_class              = "${terraform.workspace == "production" ? "${var.instance_class_production}" : "${var.instance_class}"}"
#   allocated_storage           = "${terraform.workspace == "production" ? "${var.allocated_storage_size_production}" : "${var.allocated_storage_size}"}"

#   identifier                  = "hestia-${terraform.workspace}-mysql-db"
#   name                        = "${terraform.workspace}"
#   username                    = "${var.DB_ADMIN_USERNAME}"
#   password                    = "${var.DB_ADMIN_PASSWORD}"
#   port                        = "${var.port}"
#   storage_encrypted           = "${terraform.workspace == "production" ? true : false}"

#   parameter_group_name        = "${var.default_param_group_name}"

#   deletion_protection         = "${terraform.workspace == "production" ? true : false}"

#   skip_final_snapshot         = "${terraform.workspace == "production" ? false : true}"
#   final_snapshot_identifier   = "sample-${terraform.workspace}-${md5(timestamp())}"
#   backup_retention_period     = "${terraform.workspace == "production" ? "${var.retention_period_production}" : "${var.retention_period}"}"

#   publicly_accessible         = "${terraform.workspace == "production" ? false : true}"
#   apply_immediately           = true
# }