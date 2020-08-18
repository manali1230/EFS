//make s3 bucket
resource "aws_s3_bucket" "bucky" {
  bucket = "manali12"
  acl = "public-read"
 
  tags = {
    Name  = "My-bucky"
    Environment = "Dev"
  }
}
//bucket object
resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.bucky.bucket
  acl = "public-read"
  key    = "open.png"
  source = "images/open.png"
depends_on=[aws_s3_bucket.bucky,null_resource.image]

}