# This Terraform configuration creates an S3 bucket and sets a bucket policy to allow Traject Data to replicate dataset objects.

# AWS Provider
provider "aws" {
  region  = "us-east-1"
}

# Bucket
resource "aws_s3_bucket" "trajectdata_dataset_bucket" {
  bucket = "trajectdata-dataset" # S3 bucket names must be globally unique
}

locals {
  prefix = "EXAMPLE_PREFIX/"
}

# Bucket policy
resource "aws_s3_bucket_policy" "trajectdata_dataset_bucket_policy" {
  bucket = aws_s3_bucket.trajectdata_dataset_bucket.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "Allow Traject Data to replicate dataset objects",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::111778184395:role/s3-dataset-replication-role"
        },
        "Action": [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:PutObjectTagging"
        ],
        "Resource": [
          aws_s3_bucket.trajectdata_dataset_bucket.arn,
          "${aws_s3_bucket.trajectdata_dataset_bucket.arn}/${local.prefix}/*"
        ]
      }
    ]
  })
}