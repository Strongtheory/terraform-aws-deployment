data "external" "aws_iam_authenticator" {
  program = ["bash", "auth.sh"]

  query {
    cluster_name = "${var.cluster_name}"
  }
}

provider "kubernetes" {
  alias     = "kubernetes"
  token     = "${data.external.aws_iam_authenticator.result.token}"
  version   = "~> 1.5"
}

provider "aws" {
  alias   = "aws"
  version = "~> 1.56"
}

provider "external" {
  version = "~> 1.0"
}

provider "mysql" {
  version   = "~> 1.5"
  username  = "${var.DB_ADMIN_USERNAME}"
  password  = "${var.DB_ADMIN_PASSWORD}"
  endpoint  = "${var.DB_INSTANCE_ENDPOINT}"
}

terraform {
  backend "s3" {
    bucket  = "sample-terraform-states"
    key     = "sample-cluster-services"
    region  = "ap-northeast-1"
  }
}

resource "mysql_database" "db" {
  count = "${length(var.services-db)}"
  name  = "${lookup(var.services-db[count.index], "name")}"
}

data "null_data_source" "databases" {
  count = "${length(var.services-db)}"

  inputs = {
    name                  = "${lookup(var.services-db[count.index], "name")}"
    DB_ADMIN_USERNAME     = "${var.DB_ADMIN_USERNAME}"
    db_instance_endpoint  = "${var.DB_INSTANCE_ENDPOINT}"
  }
}

resource "kubernetes_secret" "pwd" {
  metadata {
    name      = "auth"
    namespace = "${terraform.workspace}"
  }
  data {
    auth = "admin:$apr1$zDmIlKYt$zb.Fc77YqjaYrF3a5gTG20"
  }
}

resource "kubernetes_deployment" "deployments" {
  count = "${length(var.services)}"

  metadata {
    name = "${lookup(var.services[count.index], "name")}"

    labels {
      name = "${lookup(var.services[count.index], "name")}"
    }

    namespace = "${terraform.workspace}"
  }

  spec {
    replicas = "${lookup(var.services[count.index], "replicas")}"

    selector {
      match_labels {
        name = "${lookup(var.services[count.index], "name")}"
      }
    }

    template {
      metadata {
        labels {
          name = "${lookup(var.services[count.index], "name")}"
        }
      }

      spec {
        image_pull_secrets = {
          name = "docker-cfg"
        }
        container {
          image = "${lookup(var.services[count.index], "image")}:${terraform.workspace == "production" ? "${lookup(var.services[count.index], "version")}" : "${terraform.workspace}"}"
          image_pull_policy = "Always"
          name  = "${lookup(var.services[count.index], "name")}"
          env = [
            {
              name = "ENV"
              value = "${terraform.workspace}"
            },
            {
              name = "JWT_SECRET"
              value = "${var.JWT_SECRET}"
            },
            {
              name  = "DB_INSTANCE_ENDPOINT",
              value = "${var.DB_INSTANCE_ENDPOINT}"
            },
            {
              name = "DB_HOST"
              value = "${var.DB_ADMIN_USERNAME}-${terraform.workspace}-mysql-db.ccv8t9kix37w.ap-northeast-1.rds.amazonaws.com"
            },
            {
              name = "DB_ADMIN_USERNAME"
              value = "${var.DB_ADMIN_USERNAME}"
            },
            {
              name = "DB_ADMIN_PASSWORD"
              value = "${var.DB_ADMIN_PASSWORD}"
            },
          ]
          port {
            container_port = "${lookup(var.services[count.index], "target_port")}"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "services" {
  count = "${length(var.services)}"

  metadata {
    name      = "${lookup(var.services[count.index], "name")}"
    namespace = "${terraform.workspace}"
  }

  spec {
    session_affinity = "ClientIP"

    selector {
      name = "${lookup(var.services[count.index], "name")}"
    }

    port {
      name        = "http"
      port        = "${lookup(var.services[count.index], "port")}"
      target_port = "${lookup(var.services[count.index], "target_port")}"
    }
  }
}
