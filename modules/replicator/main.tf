resource "aws_msk_replicator" "this" {
  replicator_name             = var.name
  service_execution_role_arn = aws_iam_role.replicator_execution.arn

  kafka_cluster {
    amazon_msk_cluster {
      msk_cluster_arn = var.source_cluster_arn
    }

    vpc_config {
      subnet_ids         = var.source_subnet_ids
      security_groups_ids = var.source_security_group_ids
    }
  }

  kafka_cluster {
    amazon_msk_cluster {
      msk_cluster_arn = var.destination_cluster_arn
    }

    vpc_config {
      subnet_ids         = var.destination_subnet_ids
      security_groups_ids = var.destination_security_group_ids
    }
  }

  replication_info_list {
    source_kafka_cluster_arn = var.source_cluster_arn
    target_kafka_cluster_arn = var.destination_cluster_arn
    target_compression_type  = "NONE"

    topic_replication {
      topics_to_replicate = [".*"]

      topic_name_configuration {
        type = "PREFIXED_WITH_SOURCE_CLUSTER_ALIAS"
      }

      starting_position {
        type = "LATEST"
      }
    }

    consumer_group_replication {
      consumer_groups_to_replicate = [".*"]
    }
  }

  tags = {
    Environment = var.tags
  }
}


resource "aws_iam_role" "replicator_execution" {
  name = "msk-replicator-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "kafka-cluster.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_policy" "replicator_policy" {
  name        = "msk-replicator-access"
  description = "Access to source and destination MSK clusters"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kafka-cluster:Connect",
          "kafka-cluster:DescribeCluster",
          "kafka-cluster:ReadData",
          "kafka-cluster:DescribeClusterV2"
        ]
        Resource = [
          var.source_cluster_arn,
          var.destination_cluster_arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "replicator_attach" {
  role       = aws_iam_role.replicator_execution.name
  policy_arn = aws_iam_policy.replicator_policy.arn
}
