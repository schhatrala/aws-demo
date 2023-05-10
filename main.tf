provider "aws" {
  region = "us-west-2"
}

resource "aws_lambda_function" "lambdaTracingPassThrough" {
  filename                       = "lambda_function.py.zip"
  function_name                  = "ptshggalf1"
  role                           = aws_iam_role.vulnerable2.arn
  handler                        = "lambda_function.lambda_handler"
  source_code_hash               = filebase64sha256("lambda_function.py")
  code_signing_config_arn =      aws_lambda_code_signing_config.new_csc.arn
  memory_size                    = "128"
  reserved_concurrent_executions = "-1"
  runtime                        = "python3.8"
  timeout                        = "3"
  tracing_config {
    mode = "PassThrough"
  }
  vpc_config {
    security_group_ids = ["sg-51530134", "sg-71567239"]
    subnet_ids         = ["vpc-1a2b3c4d", "vpc-4hk7hui"]
  }
}
resource "aws_signer_signing_profile" "test_sp" {
  platform_id = "AWSLambda-SHA384-ECDSA"
}

resource "aws_lambda_code_signing_config" "new_csc" {
  allowed_publishers {
    signing_profile_version_arns = [
      aws_signer_signing_profile.test_sp.arn,
    ]
  }

  policies {
    untrusted_artifact_on_deployment = "Warn"
  }

  description = "My awesome code signing config."
}


resource "aws_lambda_function" "lambdaTracingNotSet" {
  filename                       = "lambda_function.py.zip"
  function_name                  = "ptshggalf2"
  role                           = aws_iam_role.vulnerable1.arn
  handler                        = "lambda_function.lambda_handler"
  source_code_hash               = filebase64sha256("lambda_function.py")
  memory_size                    = "128"
  reserved_concurrent_executions = "-1"
  runtime                        = "python3.8"
  timeout                        = "3"
  vpc_config {
    security_group_ids = []
    subnet_ids         = []
  }
}

resource "aws_lambda_provisioned_concurrency_config" "example" {
  function_name                     = aws_lambda_function.lambdaTracingNotSet.function_name
  provisioned_concurrent_executions = 1
  qualifier                         = aws_lambda_alias.test_lambda_alias.name
}

resource "aws_lambda_alias" "test_lambda_alias" {
  name             = "my_alias"
  description      = "a sample description"
  function_name    = aws_lambda_function.lambdaTracingNotSet.arn
  function_version = "1"

  routing_config {
    additional_version_weights = {
      "2" = 0.5
    }
  }
}

resource "aws_iam_role" "vulnerable2" {
  name = "test_role_3"

  assume_role_policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Principal": {
				"Service": "lambda.amazonaws.com",
				"AWS": [
					"*",
					"arn:aws:iam::*"
				]
			},
			"Action": "*"
		}
	]
}
EOF
}

resource "aws_iam_role" "vulnerable1" {
  name = "test_role_2"

  assume_role_policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Principal": {
				"Service": "lambda.amazonaws.com",
				"AWS": "*"
			},
			"Action": "*"
		}
	]
}
EOF
}
resource "aws_iam_role" "notvulnerable" {
  name = "test_role_1"

  assume_role_policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Principal": {
				"Service": "lambda.amazonaws.com",
				"AWS": "djfdkjbdja"
			},
			"Action": "*"
		}
	]
}
EOF
}

data "aws_partition" "current" {}

resource "aws_iam_role_policy_attachment" "PtShGgAirpa1" {
  role       = aws_iam_role.vulnerable2.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "PtShGgAirpa2" {
  role       = aws_iam_role.vulnerable1.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

resource "aws_lambda_function" "oldRuntime" {
  filename                       = "lambda_function.py.zip"
  function_name                  = "ptshggalf3"
  role                           = aws_iam_role.notvulnerable.arn
  handler                        = "lambda_function.lambda_handler"
  source_code_hash               = filebase64sha256("lambda_function.py")
  memory_size                    = "128"
  reserved_concurrent_executions = "-1"
  runtime                        = "python3.6"
  dead_letter_config {
    target_arn = "arn:aws:sqs:us-east-1:536274469938:delta-tesrt"
  }
  timeout                        = "3"
  tracing_config {
    mode = "Active"
  }
}

resource "aws_lambda_function" "lambdaWithSecrets" {
  layers      = []
  s3_key      = null
  handler     = "index.handler"
  publish     = null
  timeout     = "3"
  filename    = null
  image_uri   = ""
  s3_bucket   = null
  description = "Akamai Uncache resources from S3 events"
  environment {
    variables = {
      HOST                 = "akab-3qb6t4ss3ecfpz4x-yuk5e6i4s273r5f3.purge.akamaiapis.net"
      S3_REGION            = "us-east-1"
      LOGGLY_TAG           = "S3_AKAMAI_UNCACHE"
      ACCESS_TOKEN         = "akab-igahwuvebpoupigt-mzkf4mcpr6oufey3"
      CLIENT_TOKEN         = "akab-z3xuz44b5t6nm5jg-ohq3ngbuh2rmbwog"
      LOGGLY_TOKEN         = "5c0c26f6-5514-4473-a972-be037afa98b6"
      CLIENT_SECRET        = "ac_redacted(secret:strip)/ac_redacted"
      S3_ACCESS_KEY        = "AKIAILUU2NFCPWYRN3LA"
      S3_SECRET_ACCESS_KEY = "ac_redacted(secret:strip)/ac_redacted"

    }
  }
  function_name                  = "NBA-S3-Upload-Uncache-East1"
  role                           = aws_iam_role.notvulnerable.arn
  memory_size                    = "128"
  reserved_concurrent_executions = "-1"
  runtime                        = "nodejs12.x"

  package_type = "Zip"

  tracing_config {
    mode = "PassThrough"
  }

  tags = {
    Owner       = "Jesse Graupmann"
    Product     = "Uncache"
    Project     = "Uncache"
    Department  = 55201
    Environment = "PROD"
  }
}


resource "aws_lambda_provisioned_concurrency_config" "test1" {
  function_name = aws_lambda_function.lambdaTracingNotSet.function_name
  provisioned_concurrent_executions = 1
  qualifier =  aws_lambda_function.lambdaTracingPassThrough.version
}