resource "aws_vpc" "service" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "service" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id                  = aws_vpc.service.id
  cidr_block              = cidrsubnet(aws_vpc.service.cidr_block, 4, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "service" {
  vpc_id = aws_vpc.service.id
}

resource "aws_route_table" "service" {
  vpc_id = aws_vpc.service.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.service.id
  }
}

resource "aws_route_table_association" "service" {
  count = length(aws_subnet.service)

  subnet_id      = aws_subnet.service[count.index].id
  route_table_id = aws_route_table.service.id
}

