//download images from github
resource "null_resource" "image" {
  provisioner "local-exec" {
    command = "git clone https://github.com/manali1230/images.git images"
  }
}