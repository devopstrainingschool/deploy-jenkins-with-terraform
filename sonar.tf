resource "aws_instance" "sonar" {
  
  ami = var.ec2_amis
  instance_type = var.instance_type
  tenancy = "default"
  subnet_id = aws_subnet.jenkins.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  #associate_public_ip_address = "true" # adding public ip
  key_name = aws_key_pair.anael1.key_name
  tags = {
    Name = "ec2-sonar"    # for each subnet
  }
  #user_data = "${file("sonar.sh")}" # to run data1.sh script after creating
   provisioner "file" {
        source      = "sonar.sh"
        destination = "/tmp/sonar.sh"
      }
  provisioner "remote-exec"  {
    inline  = [
      "sudo yum -y install wget",
      "chmod +x /tmp/sonar.sh",
      "bash /tmp/sonar.sh"
      ]
   }
  connection {
    type         = "ssh"
    host         = self.public_ip
    user         = "centos" # change user"ec2-user" for amz
    timeout = "2m"
    agent = false
    private_key  = tls_private_key.anael2.private_key_pem      #"${file("anael.pem")}" if using outside key 
   }
  depends_on = [
    aws_key_pair.anael1
  ]
}
