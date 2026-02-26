output "primary_writer" {
  value = aws_rds_cluster.primary.endpoint
}

output "secondary_reader" {
  value = aws_rds_cluster.secondary.reader_endpoint
}