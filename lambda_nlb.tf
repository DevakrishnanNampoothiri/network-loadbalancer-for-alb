resource "aws_lambda_function" "static_nlb_80" {
  function_name = "static_nlb_80"
  filename      = "lambda_function.zip"
  handler       = "populate_NLB_TG_with_ALB.lambda_handler"
  role          = aws_iam_role.static_lb_lambda.arn

  source_code_hash = filebase64sha256("lambda_function.zip")

  runtime     = "python2.7"
  memory_size = 128
  timeout     = 300

  environment {
    variables = {
      ALB_DNS_NAME                      = var.alb_dns_name
      ALB_LISTENER                      = "80"
      S3_BUCKET                         = aws_s3_bucket.static_lb.id
      NLB_TG_ARN                        = aws_lb_target_group.network_lb_tg_80.arn
      MAX_LOOKUP_PER_INVOCATION         = 50
      INVOCATIONS_BEFORE_DEREGISTRATION = 10
      CW_METRIC_FLAG_IP_COUNT           = true
    }
  }
}

resource "aws_cloudwatch_event_rule" "cron_minute" {
  name                = "crone-minute"
  schedule_expression = "rate(1 minute)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_target" "static_nlb_80" {
  rule      = aws_cloudwatch_event_rule.cron_minute.name
  target_id = "TriggerStaticPort80"
  arn       = aws_lambda_function.static_nlb_80.arn
}

# Adding Permission for Lambda function to allow them to be triggered by CW
resource "aws_lambda_permission" "allow_cloudwatch_80" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.static_nlb_80.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cron_minute.arn
}
