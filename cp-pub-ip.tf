//copied the IP to a .txt file
resource "null_resource" "publicip"  {
	provisioner "local-exec" {
	    command = "echo  ${aws_instance.web1.public_ip} > publicip.txt"
  	}
}