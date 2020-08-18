//create instance
resource "aws_instance" "web1" {
  key_name      = aws_key_pair.enter_key_name.key_name
  ami           = "ami-0447a12f28fddb066"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.sg.name}"]
  availability_zone = "ap-south-1a"
  associate_public_ip_address = true
 connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("C:/Users/Manali Jain/Desktop/EFS-TASK-2/MyKey.pem")
    host     = aws_instance.web1.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd php git -y",
      "sudo systemctl restart httpd",
      "sudo systemctl enable httpd",
    ]

  }
tags = {
    Name = "Secure_ec2"
  }
depends_on = [
	aws_security_group.sg
]
}