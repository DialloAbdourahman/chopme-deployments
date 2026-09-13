output "cluster_id" {
  value = aws_docdb_cluster.this.id
}

output "cluster_arn" {
  value = aws_docdb_cluster.this.arn
}

output "endpoint" {
  value = aws_docdb_cluster.this.endpoint
}

output "reader_endpoint" {
  value = aws_docdb_cluster.this.reader_endpoint
}

output "port" {
  value = aws_docdb_cluster.this.port
}

output "security_group_id" {
  value = aws_security_group.this.id
}
