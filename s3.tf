resource "aws_s3_bucket" "static" {
  bucket = var.junction_host
  acl = "public-read"
  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AddPerm",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::junction.sangmin.in/*"]
    }
  ]
}
POLICY

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_s3_bucket" "junction_sam_bucket" {
  bucket = "junction-sam-bucket"
  acl = "private"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service":  "serverlessrepo.amazonaws.com"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::junction-sam-bucket/*",
      "Condition" : {
        "StringEquals": {
          "aws:SourceAccount": "273340123446"
        }
      }
    }
  ]
}
POLICY
}
