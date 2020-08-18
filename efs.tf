resource "aws_efs_file_system" "efs" {
  creation_token = "myefs"

  tags = {
    Name = "MyEFS"
  }
}

resource "aws_efs_mount_target" "target" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = aws_instance.web1.subnet_id
  security_groups = ["${aws_security_group.sg.id}"]

 depends_on = [aws_efs_file_system.efs,aws_security_group.sg,aws_instance.web1]
}

#To mount EFS volume

resource "null_resource" "nullremote" {
 depends_on = [
  aws_efs_mount_target.target,
 ]
 
 connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("C:/Users/Manali Jain/Desktop/EFS-TASK-2/MyKey.pem")
    host     = aws_instance.web1.public_ip
  }

 provisioner "remote-exec" {
  inline = [
   "sudo mount -t nfs4 ${aws_efs_mount_target.target.ip_address}:/ /var/www/html/",
   "sudo rm -rf /var/www/html/*",
   "sudo git clone https://github.com/manali1230/images.git /var/www/html/"
  ]
 }
}