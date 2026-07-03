# Create IAM role for Amazon VPC CNI Addons with trust relationship to the OIDC provider
resource "aws_iam_role" "vpc_cni_role" {
  name = "vpc-cni-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = var.aws_iam_openid_connect_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-node"
          }
        }
      }
    ]
  })
}

# Attach the AmazonEKS_CNI_Policy to the IAM role
resource "aws_iam_role_policy_attachment" "cluster_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.vpc_cni_role.name
  depends_on = [ aws_iam_role.vpc_cni_role ]
}

# Create the Amazon VPC CNI Addon for the EKS Cluster
resource "aws_eks_addon" "vpc_cni" {
  cluster_name             = var.cluster_name
  addon_name               = "vpc-cni"
  addon_version            = var.vpc_cni_addon_version
  service_account_role_arn = aws_iam_role.vpc_cni_role.arn
  configuration_values       = jsonencode({
    env = {
      AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG = "true"
      ENI_CONFIG_LABEL_DEF = "topology.kubernetes.io/zone"
      ENABLE_PREFIX_DELEGATION = "true"
    }
  })
}

resource "aws_eks_addon" "kube_proxy" {
  depends_on = [ aws_eks_addon.vpc_cni ]
  cluster_name             = var.cluster_name
  addon_name               = "kube-proxy"
  addon_version            = "v1.35.3-eksbuild.11"
}

resource "helm_release" "eks_custom_networking" {
  depends_on = [ aws_eks_addon.vpc_cni ]
  name       = "eks-custom-networking"
  chart      = "${path.module}/helm"
  namespace  = "kube-system"
  create_namespace = false
  values = [
    yamlencode({
      az1 = {
        name = "us-east-1a"
        subnet = var.secondary_pod_subnet_az1
        securityGroups = var.node_security_groups
      }
      az2 = {
        name = "us-east-1b"
        subnet = var.secondary_pod_subnet_az2
        securityGroups = var.node_security_groups
      }
    })  
  ]
}