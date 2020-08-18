//variable created to store the region
variable "region" {
  default = "ap-south-1"
}

//variable created to store the key
variable "key" {
  default = "MyKey"
}

//provider and profile
provider "aws" {
  region	= var.region
  profile	= "mymanali"
}

//generate key-pair
resource "aws_key_pair" "enter_key_name" {
  key_name   = var.key
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCu/rKXxgNMJbCUlDolSLeClqWYuBMsMm7o+WPxbQ24LtrddUCZWzBEMDpX85zQ9sWJ9G49RCyrZWPPbsXmLtroO3T2Mv01X4OYQelG2gBMrsZbYBHgA2FHT0913VRjxUpHkva0DgryjBUkaIJxxfL62FN+Pvia9h9Am5zXkG5BylEsKEOUUvSJkW71ox20aURJoDH0pvJXrgOtJ+DlWa+Muxw+WKlyXxIu9MXHuGP3Tj+4iX173upqjPr148j5FP/nnZw/VADeGDFeuwJQ1foS5+uI+6njD6tludmjEyKXnbI2NJ4kZR8KvQnlggBrJ6EhZBswqhNySGFhFYTp8sCH manali@DESKTOP-B1P0RR5"
}

output "op"{
	value = aws_key_pair.enter_key_name
}