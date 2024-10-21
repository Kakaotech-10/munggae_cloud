module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"
    
  cluster_name                   = var.cluster_name
  cluster_version                = var.cluster_version
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false
    
  cluster_addons = {
    vpc-cni = {
      before_compute = true
      most_recent    = true
      configuration_values = jsonencode({
        env = {
          ENABLE_POD_ENI                    = "true"
          ENABLE_PREFIX_DELEGATION          = "true"
          POD_SECURITY_GROUP_ENFORCING_MODE = "standard"
        }
        nodeAgent = {
          enablePolicyEventLogs = "true"
        }
        enableNetworkPolicy = "true"
      })
    }
  }
    
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
    
  create_cluster_security_group = false
  create_node_security_group    = false

  # EKS 클러스터 보안 그룹 규칙 추가
  cluster_security_group_additional_rules = {
    ingress_allow_access_from_alb = {
      description = "Allow access from ALB"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      source_security_group_id = aws_security_group.alb_sg.id
    }
  }
    
  eks_managed_node_groups = {
    default = {
      instance_types       = ["t3.medium"]
      force_update_version = true
      release_version      = var.ami_release_version
    
      min_size     = 2
      max_size     = 3
      desired_size = 3
    
      update_config = {
        max_unavailable_percentage = 50
      }
    
      labels = {
        workshop-default = "yes"
      }
    }
  }
    
  tags = merge(local.tags, {
    "karpenter.sh/discovery" = var.cluster_name
  })
}    