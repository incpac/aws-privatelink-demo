resource "aws_vpc" "consumer" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "consumer" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id                  = aws_vpc.consumer.id
  cidr_block              = cidrsubnet(aws_vpc.service.cidr_block, 4, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "consumer" {
  vpc_id = aws_vpc.consumer.id
}

resource "aws_route_table" "consumer" {
  vpc_id = aws_vpc.consumer.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.consumer.id
  }
}

resource "aws_route_table_association" "consumer" {
  count = length(aws_subnet.consumer)

  subnet_id      = aws_subnet.consumer[count.index].id
  route_table_id = aws_route_table.consumer.id
}
