resource "aws_route_table" "this" {
  vpc_id = var.vpc_id

  dynamic "route" {
    for_each = var.destination_cidr_block != "" ? [1] : []

    content {
      cidr_block     = var.destination_cidr_block
      gateway_id     = var.igw_id != "" ? var.igw_id : null
      nat_gateway_id = var.nat_gateway_id != "" ? var.nat_gateway_id : null
    }
  }

  tags = {
    Name = var.name
  }
}

resource "aws_route_table_association" "this" {
  count = length(var.subnet_ids)

  subnet_id      = var.subnet_ids[count.index]
  route_table_id = aws_route_table.this.id
}