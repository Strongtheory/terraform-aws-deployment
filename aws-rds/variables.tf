variable "allocated_storage_size" {
  description = "Storage size in GB"
  default     = "20"
}

variable "storage_type" {
  description = "Database instance storage type; (standard, gp2, io1)"
  default     = "gp2"
}

variable "engine_type" {
  description = "Server engine type"
  default     = "mysql"
}

variable "engine_version" {
  description = "Server engine version"
  default     = "5.6"
}

variable "instance_class" {
  description = "The instance type of the RDS instance."
  default     = "db.t2.micro"
}

variable "DB_ADMIN_USERNAME" {
  description = "Database instance admin username"
  type        = "string"
}

variable "DB_ADMIN_PASSWORD" {
  description = "Database instance admin password"
  type        = "string"
}

variable "port" {
  default = "3306"
}

variable "default_param_group_name" {
  default = "default.mysql5.7"
}

variable "retention_period" {
  default = "1"
}


# variable "allocated_storage_size_production" {
#   description = "Storage size in GB"
#   default     = "100"
# }

# variable "instance_class_production" {
#   description = "The instance type of the RDS instance."
#   default     = "db.r4.xlarge"
# }

# variable "retention_period_production" {
#   default = "5"
# }
