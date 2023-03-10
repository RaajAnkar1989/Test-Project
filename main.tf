resource "aws_vpc" "Test-vpc" {
  cidr_block = "10.0.0.0/16"

tags = {
    Name = "Test-vpc"
  }
}

resource "aws_internet_gateway" "test-igw" {
  vpc_id = aws_vpc.Test-vpc.id

tags = {
    Name = "Test-igw"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.Test-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "Public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.Test-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1a"
 tags = {
    Name = "Private-subnet"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.Test-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-igw.id
  }
   tags = {
    Name = "Public-rt"
  }
}

resource "aws_route_table_association" "public_subnet" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "aws-eip" {
  vpc = true
}
resource "aws_nat_gateway" "test-nat" {
  allocation_id = aws_eip.aws-eip.id
  subnet_id     = aws_subnet.public.id
  
   tags = {
    Name = "test-nat"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.Test-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.test-nat.id
  }
   tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "private_subnet" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_instance" "public-server" {
  ami           = "ami-0e3aeafe193bbdd4a"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.Allows-all.id]

tags = {
    Name = "Frontend"
  }

}
resource "aws_instance" "private-server" {
   count = length(var.tags)
   ami           = "ami-0e3aeafe193bbdd4a"
   instance_type = "t2.micro"
   subnet_id     = aws_subnet.private.id
   vpc_security_group_ids = [aws_security_group.Allows-all.id]

   tags = {
     Name = var.tags[count.index]
   }
 }
resource "aws_security_group" "Allows-all" {
  name        = "allows-all"
  description = "allow all security group"
  vpc_id      = aws_vpc.Test-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
