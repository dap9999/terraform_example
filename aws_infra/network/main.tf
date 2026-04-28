# 1. VPC 생성

resource "aws_vpc" "aws07-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.prefix}vpc"
  }
}

# 2. Subnet 생성
resource "aws_subnet" "aws07-public-subnet" {
  count             = length(var.public_subnet_cidr_block)
  vpc_id            = aws_vpc.aws07-vpc.id
  cidr_block        = var.public_subnet_cidr_block[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "${var.prefix}public-subnet-${count.index + 1}"
  }
}
resource "aws_subnet" "aws07-private-subnet" {
  count             = length(var.private_subnet_cidr_block)
  vpc_id            = aws_vpc.aws07-vpc.id
  cidr_block        = var.private_subnet_cidr_block[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "${var.prefix}private-subnet-${count.index + 1}"
  }
}

# 3. Internet Gateway 생성 및 VPC에 연결
resource "aws_internet_gateway" "aws07-igw" {
  vpc_id = aws_vpc.aws07-vpc.id
  tags = {
    Name = "${var.prefix}igw"
  }
}

# 4. NAT Gateway 생성 및 Public Subnet에 연결
resource "aws_eip" "aws07-eip" {
  domain = "vpc"
  tags = {
    Name = "${var.prefix}nat-eip"
  }
}

resource "aws_nat_gateway" "aws07-nat-gw" {
  allocation_id = aws_eip.aws07-eip.id
  subnet_id     = aws_subnet.aws07-public-subnet[0].id
  tags = {
    Name = "${var.prefix}nat-gw"
  }
}

# 5. Route Table 생성 및 라우팅 설정 (Public 1개, Private 2개)
resource "aws_route_table" "aws07-public-rt" {
  vpc_id = aws_vpc.aws07-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws07-igw.id
  }
  tags = {
    Name = "${var.prefix}public-rt"
  }
}
resource "aws_route_table_association" "aws07-public-rt-association" {
  count = length(var.public_subnet_cidr_block)
  subnet_id = aws_subnet.aws07-public-subnet[count.index].id
  route_table_id = aws_route_table.aws07-public-rt.id
}

resource "aws_route_table" "aws07-private-rt" {
  count = length(var.private_subnet_cidr_block)
  vpc_id = aws_vpc.aws07-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.aws07-nat-gw.id
  }
  tags = {
    Name = "${var.prefix}private-rt-${count.index + 1}"
  }
}
resource "aws_route_table_association" "aws07-private-rt-association" {
  count = length(var.private_subnet_cidr_block)
  subnet_id = aws_subnet.aws07-private-subnet[count.index].id
  route_table_id = aws_route_table.aws07-private-rt[count.index].id
}

# 6. Security Group 생성 - SSH-SG, HTTP-SG
resource "aws_security_group" "aws07-ssh-sg" {
  name = "${var.prefix}ssh-sg"
  description = "Allow SSH access"
  vpc_id = aws_vpc.aws07-vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.prefix}ssh-sg"
  }
}

resource "aws_security_group" "aws07-http-sg" {
  name = "${var.prefix}http-sg"
  description = "Allow HTTP access"
  vpc_id = aws_vpc.aws07-vpc.id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.prefix}http-sg"
  }
}
  




