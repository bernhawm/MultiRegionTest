resource "aws_msk_replicator" "this" {
  replicator_name             = var.name
  service_execution_role_arn = aws_iam_role.source.arn

  kafka_cluster {
    amazon_msk_cluster {
      msk_cluster_arn = aws_msk_cluster.source.arn
    }

    vpc_config {
      subnet_ids         = aws_subnet.source[*].id
      security_groups_ids  = [aws_security_group.source.id]
    }
  }

  kafka_cluster {
    amazon_msk_cluster {
      msk_cluster_arn = aws_msk_cluster.destination.arn
    }

    vpc_config {
      subnet_ids         = aws_subnet.destination[*].id
      security_groups_ids  = [aws_security_group.destination.id]
    }
  }

  replication_info_list {
    source_kafka_cluster_arn = aws_msk_cluster.source.arn
    target_kafka_cluster_arn = aws_msk_cluster.destination.arn
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
