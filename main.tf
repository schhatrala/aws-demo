provider "aws" {
  region = "us-west-2"  
}

data "aws_caller_identity" "PtShGgAci1" {}

resource "aws_sns_topic" "PtShGgAst1" {
  name = "user-updates-topic"
}

resource "aws_s3_bucket" "PtShGgAsb1" {
  bucket        = "ptshggasb1"
  acl           = "log-delivery-write"
  force_destroy = true

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::ptshggasb1"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::ptshggasb1/prefix/AWSLogs/${data.aws_caller_identity.PtShGgAci1.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_cloudwatch_log_group" "PtShGgAclg1" {
  name = "ptshggaclg1"

  tags = {
    Environment = "production"
    Application = "serviceA"
  }
}

resource "aws_kms_key" "PtShGgAkk1" {
  description             = "ptshggakk1"
  deletion_window_in_days = 10
}

resource "aws_cloudtrail" "PtShGgAc1" {
  name                          = "ptshggac1"
  s3_bucket_name                = aws_s3_bucket.PtShGgAsb1.id
  s3_key_prefix                 = ""
  include_global_service_events = true
  enable_log_file_validation    = false
  is_multi_region_trail = true
  cloud_watch_logs_group_arn    = aws_cloudwatch_log_group.PtShGgAclg1.arn
}

resource "aws_cloudtrail" "PtShGgAc2" {
  name                          = "ptshggac2"
  s3_bucket_name                = aws_s3_bucket.PtShGgAsb1.id
  s3_key_prefix                 = ""
  include_global_service_events = false
  event_selector {
    read_write_type           = "All"
    include_management_events = false
}
  is_multi_region_trail         = false
  enable_log_file_validation    = true
  cloud_watch_logs_group_arn    = aws_cloudwatch_log_group.PtShGgAclg1.arn
  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }
  }
}

resource "aws_cloudtrail" "PtShGgAc3" {
  name                          = "ptshggac3"
  s3_bucket_name                = aws_s3_bucket.PtShGgAsb1.id
  s3_key_prefix                 = ""
  include_global_service_events = true
  enable_log_file_validation    = true
  is_multi_region_trail = true
  cloud_watch_logs_group_arn    = aws_cloudwatch_log_group.PtShGgAclg1.arn
  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }
  }
}

resource "aws_cloudtrail" "PtShGgAc4" {
  name                          = "ptshggac4"
  s3_bucket_name                = aws_s3_bucket.PtShGgAsb1.id
  s3_key_prefix                 = ""
  include_global_service_events = true
  kms_key_id                    = aws_kms_key.PtShGgAkk1.arn
  enable_log_file_validation    = true
  is_multi_region_trail = true
  cloud_watch_logs_group_arn    = aws_cloudwatch_log_group.PtShGgAclg1.arn
  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }
  }
}

resource "aws_cloudtrail" "PtShGgAc5" {
  name                          = "ptshggac5"
  s3_bucket_name                = aws_s3_bucket.PtShGgAsb1.id
  s3_key_prefix                 = ""
  include_global_service_events = true
  kms_key_id                    = aws_kms_key.PtShGgAkk1.arn
  enable_log_file_validation    = false
  cloud_watch_logs_group_arn    = aws_cloudwatch_log_group.PtShGgAclg1.arn
  sns_topic_name                = aws_sns_topic.PtShGgAst1.name
  is_multi_region_trail         = true
  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }
  }
}

resource "aws_cloudtrail" "PtShGgAc6" {
  name                          = "ptshggac6"
  s3_bucket_name                = aws_s3_bucket.PtShGgAsb1.id
  s3_key_prefix                 = ""
  include_global_service_events = false
  kms_key_id                    = aws_kms_key.PtShGgAkk1.arn
  enable_log_file_validation    = true
  cloud_watch_logs_group_arn    = aws_cloudwatch_log_group.PtShGgAclg1.arn
  sns_topic_name                = aws_sns_topic.PtShGgAst1.name
  is_multi_region_trail         = true
  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }
  }
}

resource "aws_cloudtrail" "PtShGgAc7" {
  name                          = "ptshggac7"
  s3_bucket_name                = aws_s3_bucket.PtShGgAsb1.id
  s3_key_prefix                 = ""
  include_global_service_events = true
  kms_key_id                    = aws_kms_key.PtShGgAkk1.arn
  enable_log_file_validation    = true
  sns_topic_name                = aws_sns_topic.PtShGgAst1.name
  is_multi_region_trail         = true
  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }
  }
}

resource "aws_cloudtrail" "PtShGgAc8" {
  name                          = "ptshggac8"
  s3_bucket_name                = aws_s3_bucket.PtShGgAsb1.id
  s3_key_prefix                 = ""
  include_global_service_events = true
  kms_key_id                    = aws_kms_key.PtShGgAkk1.arn
  enable_log_file_validation    = true
  sns_topic_name                = aws_sns_topic.PtShGgAst1.name
  is_multi_region_trail         = true
  cloud_watch_logs_group_arn    = aws_cloudwatch_log_group.PtShGgAclg1.arn
}

resource "aws_cloudwatch_log_group" "vulnCloudWatchGrpSp" {
  name = "vulnCloudWatchGrpSp"
  kms_key_id = "kms_key_id"

  retention_in_days = 90

  tags = {
    Environment = "production"
    Application = "serviceB"
  }
}

resource "aws_cloudtrail" "vulnCloudtrailSp" {
  name = "vulnCloudtrailSp"
  s3_bucket_name = aws_s3_bucket.vulnS3BucketSp.id
  cloud_watch_logs_group_arn = aws_cloudwatch_log_group.vulnCloudWatchGrpSp.arn

  is_multi_region_trail = true
  event_selector {
    include_management_events = true
  }
}

resource "aws_cloudwatch_log_metric_filter" "vulnCloudMetricFilterSp" {
  name           = "MyAppAccessCount"
  pattern        = ""
  log_group_name = aws_cloudwatch_log_group.vulnCloudWatchGrpSp.name

  metric_transformation {
    name      = "EventCount"
    namespace = "YourNamespace"
    value     = "1"
  }
}

resource "aws_s3_bucket" "vulnS3BucketSp" {
  bucket = "vulnS3BucketSp"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
