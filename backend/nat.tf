# resource "aws_eip" "nat" {
#   domain = "vpc"
# }

# resource "aws_nat_gateway" "nat_gw" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.subnet1.id

#   depends_on = [aws_internet_gateway.gw]
# }

# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat_gw.id
#   }
#   tags = {
#     Name = "private"
#   }
# }

# resource "aws_route_table_association" "subnet3" {
#   subnet_id      = aws_subnet.subnet3.id
#   route_table_id = aws_route_table.private.id
# }
