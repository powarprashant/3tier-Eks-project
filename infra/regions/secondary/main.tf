module "vpc" {
  source = "../../modules/vpc"

  providers = {
    aws = aws.secondary
  }

  name            = "secondary-vpc"
  cidr            = "10.1.0.0/16"
  azs             = ["ap-south-1a", "ap-south-1b"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
  public_subnets  = ["10.1.3.0/24", "10.1.4.0/24"]
}

module "eks" {
  source = "../../modules/eks"

  providers = {
    aws = aws.secondary
  }

  cluster_name    = "three-tier-secondary"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
}