resource "aws_vpc" "eks_vpc" {

  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "${var.cluster_name}-igw"
  }
}

resource "aws_subnet" "public" {

  count = length(var.public_subnets)

  vpc_id = aws_vpc.eks_vpc.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = var.azs[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.cluster_name}-public-${count.index}"

    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.eks_vpc.id

  route {

    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id

  }

  tags = {
    Name = "${var.cluster_name}-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {

  count = length(var.public_subnets)

  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id

}