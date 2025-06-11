resource "aws_s3_bucket" "msk_logs" {
  bucket = "msk-broker-logs-bucket-wade-test"
    force_destroy = true

}

# resource "aws_s3_bucket_acl" "bucket_acl" {
#   bucket = aws_s3_bucket.msk_logs.id
#   acl    = "private"
# }

resource "aws_s3_bucket_policy" "msk_logs_policy" {
  bucket = aws_s3_bucket.msk_logs.id
  policy = data.aws_iam_policy_document.allow_msk_access.json
}

data "aws_iam_policy_document" "allow_msk_access" {
  statement {
    sid    = "AllowMSKToPutLogs"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["kafka.amazonaws.com"]
    }

    actions = [
      "s3:PutObject",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation"
    ]

    resources = [
      "${aws_s3_bucket.msk_logs.arn}",
      "${aws_s3_bucket.msk_logs.arn}/*"
    ]
  }
}







#######################################
###################Replicator
#######################################

