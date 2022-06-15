module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.23.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.20"
  subnet_ids = module.vpc.private_subnets

  vpc_id = module.vpc.vpc_id


  # Fargate Profile(s)

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    disk_size      = 45
    instance_types = ["c5.large", "c6a.large"]
    block_device_mappings = {
      xvda = {
        device_name = "/dev/xvda"
        ebs         = {
          volume_size           = 32
          volume_type           = "gp3"
          iops                  = 3000
          throughput            = 125
          encrypted             = true
          delete_on_termination = true
        }
      }
    }
  }

  eks_managed_node_groups = {
    fppp = {
      min_size     = 1
      max_size     = 3
      desired_size = 1
      disk_size      = 62

      instance_types = ["t3.small"]
      capacity_type = "SPOT"
    }
    green = {
      min_size     = 1
      max_size     = 3
      desired_size = 1

      instance_types = ["t3.small"]
      capacity_type  = "SPOT"
    }
    whi = {
      min_size     = 1
      max_size     = 3
      desired_size = 1

      instance_types = ["t3.small"]
      disk_size = 37
    }
  }

}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
