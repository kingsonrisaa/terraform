#create resource s3 and bucket policy
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
      "Principal": {
                "AWS": "arn:aws:iam::743512395119:user/User_Terraform"
            },
      "Action": "s3:ListBucket",
      "Resource": [ "arn:aws:s3:::${aws_s3_bucket.terraformstate.id}",
        "arn:aws:s3:::${aws_s3_bucket.terraformstate.id}/*"
	]
    },
    {
      "Effect": "Allow",
      "Principal": {
                "AWS": "arn:aws:iam::743512395119:user/User_Terraform"
            },
      "Action": ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
      "Resource": [ "arn:aws:s3:::${aws_s3_bucket.terraformstate.id}",
        "arn:aws:s3:::${aws_s3_bucket.terraformstate.id}/*"
        ]
    }
  ]
}
EOF
}

#create dynamodb table

resource "aws_dynamodb_table" "statelock-dynamodb" {
  name = "statelock-dynamodb"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "tflockid"
  attribute {
    name = "tflockid"
    type = "S"
  }
}

