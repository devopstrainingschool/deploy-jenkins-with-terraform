resource "aws_internet_gateway" "jenkins_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "jenkins_igw"
  }
}