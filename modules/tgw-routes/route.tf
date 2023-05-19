resource "aws_route" "source-route" {
  for_each                  = {for route-table in var.source_route_tables: route-table => true }
  route_table_id            = each.key
  destination_cidr_block    = var.destination_cidr
  transit_gateway_id        = var.transit_gateway_id
}

resource "aws_route" "destination-route" {
  for_each                  = {for route-table in var.destination_route_tables: route-table => true }
  route_table_id            = each.key
  destination_cidr_block    = var.source_cidr
  transit_gateway_id        = var.transit_gateway_id
}
