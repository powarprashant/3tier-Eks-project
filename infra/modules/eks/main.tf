module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  eks_managed_node_groups = {

    frontend = {
      instance_types = ["t3.medium"]
      desired_size   = 1
      min_size       = 1
      max_size       = 2

      labels = {
        role = "frontend"
      }

      taints = [{
        key    = "tier"
        value  = "frontend"
        effect = "NO_SCHEDULE"
      }]
    }

    backend = {
      instance_types = ["t3.medium"]
      desired_size   = 1
      min_size       = 1
      max_size       = 2

      labels = {
        role = "backend"
      }

      taints = [{
        key    = "tier"
        value  = "backend"
        effect = "NO_SCHEDULE"
      }]
    }
  }
}