# Create VPC with public and private subnets
module "create_vpc" {
    source                      = "./modules/vpc"
    vpc_name                    = var.vpc_name
    vpc_cidr                    = var.vpc_cidr
    azs                         = var.azs
    public_subnets              = var.elb_public_subnets
    public_subnet_names         = var.elb_public_subnets_names
    private_subnets             = concat(var.app_private_subnets, var.db_private_subnets)
    private_subnet_names        = concat(var.app_private_subnet_names, var.db_private_subnet_names)
    cluster_name                = var.eks_cluster_name
    tags                        = var.tags
}

# Create EKS cluster-standard.
module "create_eks_standard_cluster" {
    source = "./modules/eks-standard"
    cluster_name = var.eks_cluster_name
    private_subnet_ids = module.create_vpc.private_subnets
    public_subnet_ids = slice(module.create_vpc.public_subnets, 0, 2)
    cluster_admin_role_arn = var.cluster_admin_role_arn
    tags = var.tags
    depends_on = [ module.create_vpc ]
}

# Deploy Amazon VPC CNI Addon for EKS cluster.
module "install_vpc_cni" {
  source = "./modules/eks-addons/amazon-vpc-cni"
  cluster_name = var.eks_cluster_name
  vpc_cni_addon_version = var.vpc_cni_addon_version
  secondary_pod_subnet_az1 = module.create_vpc.public_subnets[0]
  secondary_pod_subnet_az2 = module.create_vpc.public_subnets[1]
  node_security_groups = [module.create_eks_standard_cluster.cluster_security_group_id]
  aws_iam_openid_connect_provider_arn = module.create_eks_standard_cluster.aws_iam_openid_connect_provider_arn
  tags = var.tags
  depends_on = [ module.create_eks_standard_cluster, module.create_vpc ]
}

# Create EKS cluster-auto-mode.
# module "create_eks_auto_mode_cluster" {
#     source = "./modules/eks-auto-mode"
#     cluster_name = var.eks_cluster_name
#     private_subnet_ids = module.create_vpc.private_subnets
#     public_subnet_ids = module.create_vpc.public_subnets
#     cluster_admin_role_arn = var.cluster_admin_role_arn
#     tags = var.tags
#     depends_on = [ module.create_vpc ]
# }

# Create self-managed node group for EKS cluster with AL2 AMI.
# module "create_self_managed_node_group_al2" {
#     source = "./modules/eks-compute/self-managed-node-group-al2"
#     vpc_id = module.create_vpc.vpc_id
#     worker_node_name = var.worker_node_name
#     private_subnet_ids = module.create_vpc.private_subnets
#     public_subnet_ids = module.create_vpc.public_subnets
#     cluster_security_group_id = module.create_eks_standard_cluster.cluster_security_group_id
#     cluster_name = var.eks_cluster_name
#     node_group_desired_capacity = var.node_group_desired_capacity
#     node_group_max_size = var.node_group_max_size
#     node_group_min_size = var.node_group_min_size
#     depends_on = [ module.create_eks_standard_cluster, module.install_vpc_cni ]
# }

# Create AWS Managed Node Group for EKS cluster with AL2023 AMI.
module "create_managed_node_group_al2023" {
    source = "./modules/eks-compute/managed-node-group-al2023"
    vpc_id = module.create_vpc.vpc_id
    worker_node_name = var.worker_node_name
    private_subnet_ids = module.create_vpc.private_subnets
    public_subnet_ids = slice(module.create_vpc.public_subnets, 0, 2)
    cluster_security_group_id = module.create_eks_standard_cluster.cluster_security_group_id
    cluster_name = var.eks_cluster_name
    node_group_desired_capacity = var.node_group_desired_capacity
    node_group_max_size = var.node_group_max_size
    node_group_min_size = var.node_group_min_size
    certificate_authority_data = module.create_eks_standard_cluster.certificate_authority_data
    cluster_endpoint = module.create_eks_standard_cluster.cluster_endpoint
    service_ipv4_cidr = module.create_eks_standard_cluster.service_ipv4_cidr
    depends_on = [ module.create_eks_standard_cluster, module.install_vpc_cni ]
}

# module "deploy_cluster_autoscaler" {
#   source = "./modules/eks-compute/kubernetes-cluster-autoscaler"
#   cluster_name = var.eks_cluster_name
#   aws_iam_openid_connect_provider_arn = module.create_eks_standard_cluster.aws_iam_openid_connect_provider_arn
#   tags = var.tags
#   depends_on = [ module.create_managed_node_group_al2023 ]
# }

# Create AWS Managed Node Group for EKS cluster with Bottlerocket AMI.
# module "create_managed_node_group-bottlerocket" {
#     source = "./modules/eks-compute/managed-node-group-bottlerocket"
#     vpc_id = module.create_vpc.vpc_id
#     worker_node_name = var.worker_node_name
#     private_subnet_ids = module.create_vpc.private_subnets
#     public_subnet_ids = module.create_vpc.public_subnets
#     cluster_security_group_id = module.create_eks_standard_cluster.cluster_security_group_id
#     cluster_name = var.eks_cluster_name
#     node_group_desired_capacity = var.node_group_desired_capacity
#     node_group_max_size = var.node_group_max_size
#     node_group_min_size = var.node_group_min_size
#     certificate_authority_data = module.create_eks_standard_cluster.certificate_authority_data
#     cluster_endpoint = module.create_eks_standard_cluster.cluster_endpoint
#     service_ipv4_cidr = module.create_eks_standard_cluster.service_ipv4_cidr
#     depends_on = [ module.create_eks_standard_cluster, module.install_vpc_cni ]
# }

# Create Fargate Profile for EKS cluster.
# module "create-fargate_profile" {
#     source = "./modules/eks-standard/fargate-profile"
#     cluster_name = var.eks_cluster_name
#     private_subnet_ids = module.create_vpc.private_subnets
#     tags = var.tags
#     depends_on = [ module.create_eks_standard_cluster ]
# }

# Create AWS Managed Node Group for EKS cluster with AL2023 AMI.
# module "create_karpenter_node_group_al2023" {
#     source = "./modules/eks-compute/karpenter-node-group-al2023"
#     vpc_id = module.create_vpc.vpc_id
#     karpenter_controller_node_name = var.karpenter_controller_node_name
#     private_subnet_ids = module.create_vpc.private_subnets
#     public_subnet_ids = module.create_vpc.public_subnets
#     cluster_security_group_id = module.create_eks_standard_cluster.cluster_security_group_id
#     cluster_name = var.eks_cluster_name
#     node_group_desired_capacity = var.node_group_desired_capacity
#     node_group_max_size = var.node_group_max_size
#     node_group_min_size = var.node_group_min_size
#     certificate_authority_data = module.create_eks_standard_cluster.certificate_authority_data
#     cluster_endpoint = module.create_eks_standard_cluster.cluster_endpoint
#     service_ipv4_cidr = module.create_eks_standard_cluster.service_ipv4_cidr
#     coredns_addon_version = var.coredns_addon_version
#     depends_on = [ module.create_eks_standard_cluster, module.install_vpc_cni ]
# }

# Deploy Karpenter controller for EKS cluster.
# module "deploy-karpenter-controller" {
#   source = "./modules/eks-compute/karpenter-controller"
#   cluster_name = var.eks_cluster_name
#   aws_iam_openid_connect_provider_arn = module.create_eks_standard_cluster.aws_iam_openid_connect_provider_arn
#   tags = var.tags
#   depends_on = [ module.create_eks_standard_cluster, module.create_karpenter_node_group_al2023 ]
# }

# Create Karpenter node pool for EKS cluster.
# module "create_karpenter_node_pool_al2023" {
#   source                      = "./modules/eks-compute/karpenter-node-pool-al2023"
#   cluster_name                = var.eks_cluster_name
#   certificate_authority_data  = module.create_eks_standard_cluster.certificate_authority_data
#   cluster_endpoint            = module.create_eks_standard_cluster.cluster_endpoint
#   service_ipv4_cidr           = module.create_eks_standard_cluster.service_ipv4_cidr
#   vpc_id                      = module.create_vpc.vpc_id
#   cluster_security_group_id   = module.create_eks_standard_cluster.cluster_security_group_id
#   karpenter_worker_node_name  = var.karpenter_worker_node_name
#   karpenter_controller_node_name = var.karpenter_controller_node_name
#   karpenter_node_role_arn     = module.create_karpenter_node_group_al2023.karpenter_node_group_iam_role_arn
#   depends_on                  = [ module.deploy-karpenter-controller ]
# }

# Deploy Ingress Controller for EKS cluster.
# module "install_ingress_controller" {
#   source = "./modules/eks-addons/ingress-controller"
#   cluster_name = var.eks_cluster_name
#   vpc_id = module.create_vpc.vpc_id
#   aws_iam_openid_connect_provider_arn = module.create_eks_standard_cluster.aws_iam_openid_connect_provider_arn
#   tags = var.tags
#   depends_on = [ module.create_managed_node_group_al2023 ]
# }

# Deploy Amazon EBS CSI Driver for EKS cluster.
# module "install_ebs_csi_driver" {
#   source = "./modules/eks-addons/amazon-ebs-csi-driver"
#   cluster_name = var.eks_cluster_name
#   aws_iam_openid_connect_provider_arn = module.create_eks_standard_cluster.aws_iam_openid_connect_provider_arn
#   tags = var.tags
#   depends_on = [ module.create_managed_node_group_al2023 ]
# }

# Deploy Amazon EFS CSI Driver for EKS cluster.
# module "install_efs_csi_driver" {
#   source = "./modules/eks-addons/amazon-efs-csi-driver"
#   cluster_name = var.eks_cluster_name
#   aws_iam_openid_connect_provider_arn = module.create_eks_standard_cluster.aws_iam_openid_connect_provider_arn
#   tags = var.tags
#   depends_on = [ module.create_managed_node_group_al2023 ]
# }

# module "install_matrix_server" {
#   source = "./modules/eks-addons/matrix-server"
#   cluster_name = var.eks_cluster_name
#   matrix_server_version = var.matrix_server_version
#   depends_on = [ module.create_eks_standard_cluster ]
# }

# module "create_ecr_repo" {
#   source = "./modules/ecr-repository"
#   ecr_repo_name = var.ecr_repo_name
# }