resource "aws_instance" "jenkins" {
  
  ami = var.ec2_amis
  instance_type = var.instance_type
  tenancy = "default"
  subnet_id = aws_subnet.jenkins.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  #associate_public_ip_address = "true" # adding public ip
  key_name = aws_key_pair.anael1.key_name
  tags = {
    Name = "ec2-jenkins"    # for each subnet
  }
  # copy pem key to my ec2
  provisioner "file" {
        source      = "docker.sh"
        destination = "/tmp/docker.sh"
      }
 # user_data = "${file("data1.sh")}" # to run data1.sh script after creating
  provisioner "remote-exec"  {
    inline  = [
      "sudo yum install -y jenkins java-11-openjdk-devel",
      "sudo yum -y install wget",
      "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
      "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key",
      "sudo yum upgrade -y",
      "sudo yum install jenkins -y",
      "sudo yum install git -y",  # added but never tested
      "sudo chmod +x /tmp/docker.sh",  # added but never tested
      "bash /tmp/docker.sh",  # added but never tested
      "sudo systemctl start jenkins",
      "sudo systemctl enable jenkins",
      #"chmod 777 /var/run/docker.sock" # added but never tested
    
      ]
   }
  connection {
    type         = "ssh"
    host         = self.public_ip
    user         = "centos" # change user"ec2-user" for amz
    timeout = "2m"
    agent = false
    private_key  = tls_private_key.anael2.private_key_pem #"${file("anael.pem")}" 
   }
  depends_on = [
    aws_key_pair.anael1
  ]
 
}

# Installing slave node

resource "aws_instance" "slave" {
  
  ami = var.ec2_amis
  instance_type = var.instance_type
  tenancy = "default"
  subnet_id = aws_subnet.jenkins.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  #associate_public_ip_address = "true" # adding public ip
  key_name = aws_key_pair.anael1.key_name
  tags = {
    Name = "ec2-slave"    # for each subnet
  }
 # user_data = "${file("data1.sh")}" # to run data1.sh script after creating or you can use the below
 provisioner "file" {
        source      = "sonar.sh"
        destination = "/tmp/sonar.sh"
      }
  provisioner "remote-exec"  {
    inline  = [
      "sudo yum install -y jenkins java-11-openjdk-devel",
      "sudo yum -y install wget",
      "chmod +x /tmp/sonar.sh",
      "bash /tmp/sonar.sh",
      "sudo yum install git -y",  # added but never tested
      #"chmod 777 /var/run/docker.sock"  # added but never tested
      ]
   }
  connection {
    type         = "ssh"
    host         = self.public_ip
    user         = "centos" # change user"ec2-user" for amz
    timeout = "2m"
    agent = false
    private_key  = tls_private_key.anael2.private_key_pem #"${file("anael.pem")}" 
   }
  depends_on = [
    aws_key_pair.anael1
  ]
 
}