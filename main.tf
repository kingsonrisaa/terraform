#create resource
resource "aws_s3_bucket" "terraformstate" {
  bucket = "mytfstatetestbucket020202"
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm     = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_policy" "bucket-policy-terraform" {
    bucket = aws_s3_bucket.terraformstate.id
    policy = <<EOF
{   "Version": "2012-10-17",
    "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.terraformstate.id}"
    },
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
      "Resource": "arn:aws:s3:::${aws_s3_bucket.terraformstate.id}"
    }
  ]
}
EOF
}
