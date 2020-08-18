//make cloudfront distribution
resource "aws_cloudfront_distribution" "prod_distribution" {
    origin {
         domain_name = "${aws_s3_bucket.bucky.bucket_regional_domain_name}"
         origin_id   = "${aws_s3_bucket.bucky.id}"
 
        custom_origin_config {
            http_port = 80
            https_port = 443
            origin_protocol_policy = "match-viewer"
            origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
        }
    }
    # By default, show index.html file
    default_root_object = "index.php"
    enabled = true
    # If there is a 404, return index.html with a HTTP 200 Response
    custom_error_response {
        error_caching_min_ttl = 3000
        error_code = 404
        response_code = 200
        response_page_path = "/index.php"
    }

default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${aws_s3_bucket.bucky.id}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE","IN"]
    }
  }

    # SSL certificate for the service.
    viewer_certificate {
        cloudfront_default_certificate = true
    }
 depends_on=[aws_s3_bucket.bucky,aws_efs_file_system.efs,aws_security_group.sg,aws_instance.web1,aws_efs_mount_target.target]
}

resource "null_resource" "cfssh"  {
depends_on = [  aws_efs_mount_target.target,aws_cloudfront_distribution.prod_distribution]
     connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("C:/Users/Manali Jain/Desktop/EFS-TASK-2/MyKey.pem")
    host     = aws_instance.web1.public_ip
  }
}
resource "null_resource" "nullremote3"  {

depends_on = [
    aws_s3_bucket.bucky,aws_efs_file_system.efs,aws_security_group.sg,aws_instance.web1,aws_efs_mount_target.target,null_resource.cfssh,aws_cloudfront_distribution.prod_distribution
  ]
 connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("C:/Users/Manali Jain/Desktop/EFS-TASK-2/MyKey.pem")
    host     = aws_instance.web1.public_ip
  }

provisioner "remote-exec" {
    inline = [
      "sudo su << EOF",
            "echo \"${aws_cloudfront_distribution.prod_distribution.domain_name}\" >> /var/www/html/path.txt",
            "EOF",
      "sudo systemctl restart httpd"
    ]
  }
}


//open the website in chrome
resource "null_resource" "chromeopen"  {
depends_on = [
    null_resource.nullremote3,
  ]
	provisioner "local-exec" {
	    command = "chrome  ${aws_instance.web1.public_ip}"
  	}
}
