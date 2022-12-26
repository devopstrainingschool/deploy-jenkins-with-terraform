resource "aws_subnet" "jenkins" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true # assign public ip to instances
  tags = {
    Name = "Subnet-jenkins"
  }
}

resource "aws_subnet" "sonar" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true # assign public ip to instances
  tags = {
    Name = "Subnet-sonar"
  }
}