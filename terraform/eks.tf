module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  # Cluster Configuration
  cluster_name                            = "sandbox"
  cluster_version                        = "1.29"
  cluster_endpoint_public_access         = true
  enable_cluster_creator_admin_permissions = true

  # Network Configuration
  vpc_id     = aws_vpc.main.id
  subnet_ids = [
    aws_subnet.private_subnet1.id,
    aws_subnet.private_subnet2.id
  ]

  # Node Group Defaults
  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  # Managed Node Groups
  eks_managed_node_groups = {
    ng-one = {
      name = "node-group-1"

      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 1
      desired_size = 1
    }
  }

  tags = {
    Environment = "sandbox"
    Terraform   = "true"
  }
}
