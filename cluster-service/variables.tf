variable "services" {
  type = "list"
  default = [
    {
      name          = "web",
      image         = "<alias ID>.dkr.ecr.<AZ>.amazonaws.com/sample/web",
      version       = "1.0.0",
      replicas      = 1
      port          = 80,
      target_port   = 3000,
    },
    {
      name          = "gateway",
      image         = "<alias ID>.dkr.ecr.<AZ>.amazonaws.com/sample/gateway",
      version       = "1.0.0",
      replicas      = 1
      port          = 80,
      target_port   = 3000,
    },
    {
      name          = "auth",
      image         = "<alias ID>.dkr.ecr.<AZ>.amazonaws.com/sample/auth",
      version       = "1.0.0",
      replicas      = 1
      port          = 3000,
      target_port   = 3000,
    },
    {
      name          = "user",
      image         = "<alias ID>.dkr.ecr.<AZ>.amazonaws.com/sample/user",
      version       = "1.0.0",
      replicas      = 1
      port          = 3000,
      target_port   = 3000,
    },
  ]
}

variable "services-db" {
  type = "list"
  default = [
    {
      name = "auth"
    },
    {
      name = "user"
    },
  ]
}

variable "cluster_name" {
  default = "sample-cluster"
}

variable "JWT_SECRET" {
  type = "string"
}

variable "DB_ADMIN_USERNAME" {
  description = "Database instance admin username"
  type        = "string"
}

variable "DB_ADMIN_PASSWORD" {
  description = "Database instance admin password"
  type        = "string"
}

variable "DB_INSTANCE_ENDPOINT" {
  description = "Database instance endpoint url"
  type        = "string"
}