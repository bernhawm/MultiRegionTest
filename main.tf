


provider "aws" {
  region = "us-east-2" # Change to your preferred region
  alias = "us-east-2" # Change to your preferred region

}


provider "aws" {
  region = "us-east-1" # Change to your preferred region
  alias = "us-east-1" # Change to your preferred region

}

module "global" {
  source = "./modules/global"

  region= "us-east-2"
  tags = "Global"
  
  providers = {
    aws = aws.us-east-2
  }
}

module "us-east-2" {
  source = "./modules/regional"
  shared_bucket_name = module.global.bucket_name
#   kms_arn = module.us-east-2.kms.arn
  cidr_block =var.cidr_block_use2
  subnet_cidrs = var.subnet_cidrs_use2
  region= "us-east-2"
  tags = "Main"
  providers = {
    aws = aws.us-east-2
  }
}

module "us-east-1" {
  source = "./modules/regional"
  shared_bucket_name = module.global.bucket_name
  cidr_block =var.cidr_block_use1
  subnet_cidrs = var.subnet_cidrs_use1
#   kms_arn = module.us-east-1.kms.arn
  region= "us-east-1"
  tags = "DR"

  providers = {
    aws = aws.us-east-1
  }
}

module "replicator" {
  source = "./modules/replicator"

  source_cluster_arn      = module.us-east-2.msk_cluster_arn
  destination_cluster_arn = module.us-east-1.msk_cluster_arn
  source_subnet_ids       = module.us-east-2.subnet_ids
  destination_subnet_ids  = module.us-east-1.subnet_ids
  source_security_group_ids = module.us-east-2.msk_security_group_ids
  destination_security_group_ids = module.us-east-1.msk_security_group_ids
  name                    = "useast2-to-useast1"
  tags                    = "replication"

  providers = {
    aws = aws.us-east-1
  }
}