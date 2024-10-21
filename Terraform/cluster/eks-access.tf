# EKS 접근을 위한 IAM 역할 생성
resource "aws_iam_role" "eks_access_role" {
  name = "eks-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# EKS 접근 정책 연결
resource "aws_iam_role_policy_attachment" "eks_access_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_access_role.name
}

# EKS 클러스터에 IAM 역할 매핑
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = aws_iam_role.eks_access_role.arn
        username = "eks-access-role"
        groups   = ["system:masters"]
      },
      {
        rolearn  = module.eks.eks_managed_node_groups["default"].iam_role_arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers", "system:nodes"]
      }
    ])
  }

  depends_on = [module.eks.eks_managed_node_groups]
}