output "db_instance_identifier" {
  value = "${aws_db_instance.db_instance_sample.identifier}"
}

output "db_instance_endpoint" {
  value = "${aws_db_instance.db_instance_sample.endpoint}"
}