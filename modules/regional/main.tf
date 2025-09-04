# resource "aws_lambda_function" "test_lambda" {
#   # If the file is not in the current working directory you will need to include a
#   # path.module in the filename.
#   filename      = "lambda_function_payload.zip"
#   function_name = "lambda_function_name"
#   role          = aws_iam_role.iam_for_lambda.arn
#   handler       = "index.test"

#   source_code_hash = data.archive_file.lambda.output_base64sha256

#   runtime = "nodejs18.x"

#   environment {
#     variables = {
#       foo = "bar"
#     }
#   }
# }



# data "archive_file" "lambda" {
#   type        = "zip"
#   source_file = "lambda.js"
#   output_path = "lambda_function_payload.zip"
# }


resource "aws_cloudwatch_log_group" "msk_logs" {
  name = "msk_broker_logs_${var.region}"
  retention_in_days = 7
  tags = {
    Environment = var.tags
    Region      = var.region
  }
}

resource "aws_kms_key" "kms" {
  description = "example"
}



resource "aws_msk_cluster" "example" {
  cluster_name           = "WadeTest-${var.region}"
  kafka_version          = "3.2.0"
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type = "kafka.t3.small"
    client_subnets = [
      aws_subnet.main.id,
      aws_subnet.az2.id,
      aws_subnet.az3.id,
    ]
    storage_info {
      ebs_storage_info {
        volume_size = 10
      }
    }
    security_groups = [
      aws_security_group.sg.id,
    ]
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.kms.arn
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = true
      }
      node_exporter {
        enabled_in_broker = true
      }
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.msk_logs.name
      }
   
      s3 {
        enabled = true
        bucket  = var.shared_bucket_name
        prefix  = "logs/msk-${var.region}"
      }
    }
  }

  tags = {
    region = var.region
  }
}

