resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.tags
  }
}

data "aws_availability_zones" "azs" {
  state = "available"
}


resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidrs[0]
    availability_zone = data.aws_availability_zones.azs.names[0]
  tags = {
    Name = var.tags
  }

}
resource "aws_subnet" "az2" {
  vpc_id     = aws_vpc.vpc.id
    cidr_block        = var.subnet_cidrs[1]
    availability_zone = data.aws_availability_zones.azs.names[1]
  tags = {
    Name = var.tags
  }

}
resource "aws_subnet" "az3" {
  vpc_id     = aws_vpc.vpc.id
    cidr_block        = var.subnet_cidrs[2]
    availability_zone = data.aws_availability_zones.azs.names[2]
  tags = {
    Name = var.tags
  }

}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc.id
}
