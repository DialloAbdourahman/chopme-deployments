resource "aws_docdb_subnet_group" "this" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name        = "${var.name}-subnet-group"
    Environment = var.environment
  }
}

resource "aws_security_group" "this" {
  name        = "${var.name}-sg"
  description = "Security group for DocumentDB"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow MongoDB traffic from ECS"
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = var.allowed_security_group_ids
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name}-sg"
    Environment = var.environment
  }
}

resource "aws_docdb_cluster" "this" {
  cluster_identifier = var.name

  engine = "docdb"

  master_username = var.master_username
  master_password = var.master_password

  db_subnet_group_name   = aws_docdb_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]

  port = 27017

  backup_retention_period = var.backup_retention_period

  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window

  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier

  tags = {
    Name        = var.name
    Environment = var.environment
  }
}

resource "aws_docdb_cluster_instance" "this" {
  count = var.instance_count

  identifier         = "${var.name}-${count.index + 1}"
  cluster_identifier = aws_docdb_cluster.this.id

  instance_class = var.instance_class

  engine = "docdb"

  auto_minor_version_upgrade = true

  tags = {
    Name        = "${var.name}-${count.index + 1}"
    Environment = var.environment
  }
}
