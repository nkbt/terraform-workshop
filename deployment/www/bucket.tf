resource "aws_s3_bucket" "www" {
  bucket        = local.bucket_name
  acl           = "public-read"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}


data "aws_iam_policy_document" "www_policy_doc" {
  statement {
    actions = ["s3:GetObject"]
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    resources = ["arn:aws:s3:::${local.bucket_name}/*"]
  }
}


resource "aws_s3_bucket_policy" "www_policy" {
  bucket = aws_s3_bucket.www.id
  policy = data.aws_iam_policy_document.www_policy_doc.json
}

output "www_url" {
  value = "http://${aws_s3_bucket.www.website_endpoint}"
}
