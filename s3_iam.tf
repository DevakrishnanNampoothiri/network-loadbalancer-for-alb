# Provide bucket-name as per your wish.

resource "aws_s3_bucket" "static_lb" {
  bucket = "nlb-for-alb-develop"
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_iam_role_policy" "static_lb_lambda" {
  name = "static-lb-lambda"
  role = aws_iam_role.static_lb_lambda.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ],
      "Effect": "Allow",
      "Sid": "LambdaLogging"
    },
    {
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.static_lb.arn}/*"
      ],
      "Effect": "Allow",
      "Sid": "S3"
    },
    {
      "Action": [
        "elasticloadbalancing:RegisterTargets",
        "elasticloadbalancing:DeregisterTargets"
      ],
      "Resource": [
        "${aws_lb_target_group.network_lb_tg_80.arn}"
      ],
      "Effect": "Allow",
      "Sid": "ChangeTargetGroups"
    },
    {
      "Action": [
        "elasticloadbalancing:DescribeTargetHealth"
      ],
      "Resource": "*",
      "Effect": "Allow",
      "Sid": "DescribeTargetGroups"
    },
    {
      "Action": [
        "cloudwatch:putMetricData"
      ],
      "Resource": "*",
      "Effect": "Allow",
      "Sid": "CloudWatch"
    }
  ]
}
EOF
}

resource "aws_iam_role" "static_lb_lambda" {
  name        = "static-lb-lambda"
  description = "Managed by Terraform"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
