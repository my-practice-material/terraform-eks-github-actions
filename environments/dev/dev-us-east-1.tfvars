# Terraform Variables for Dev Environment in US East 1 Region

# VPC Configuration
vpc_name = "study-vpc"
vpc_cidr = "10.10.0.0/20"
secondary_cidr_blocks = ["100.64.0.0/16"]
azs = ["us-east-1a", "us-east-1b"]
elb_public_subnets = ["10.10.1.0/24", "10.10.2.0/24", "100.64.0.0/22", "100.64.4.0/22"]
elb_public_subnets_names = ["study-vpc-elb-pub-sbnt-az1", "study-vpc-elb-pub-sbnt-az2", "secondary-pod-subnet-az1", "secondary-pod-subnet-az2"]
app_private_subnets = ["10.10.3.0/24", "10.10.4.0/24"]
app_private_subnet_names = ["study-vpc-app-priv-sbnt-az1", "study-vpc-app-priv-sbnt-az2"]
db_private_subnets = ["10.10.5.0/24", "10.10.6.0/24"]
db_private_subnet_names = ["study-vpc-db-priv-sbnt-az1", "study-vpc-db-priv-sbnt-az2"]
secondary_pod_subnet_az1_name = "secondary-pod-subnet-az1"
secondary_pod_subnet_az2_name = "secondary-pod-subnet-az2"

# EKS Cluster Configuration
eks_cluster_name = "study-eks-cluster"
worker_node_name = "study-eks-worker-node"
node_group_desired_capacity = 2
node_group_max_size = 3
node_group_min_size = 1
cluster_admin_role_arn = "arn:aws:iam::360496493654:role/aws-reserved/sso.amazonaws.com/ap-south-1/AWSReservedSSO_AdministratorAccess_c3baec8c61b153ee"

vpc_cni_addon_version = "v1.21.1-eksbuild.1" # check latest
coredns_addon_version = "v1.12.1-eksbuild.2" # check latest
matrix_server_version = "v0.8.1-eksbuild.6" # check latest
karpenter_controller_node_name = "karpenter-controller-node"
karpenter_worker_node_name = "karpenter-worker-node"

ecr_repo_name = "study/study-ecr-repo"

# Mandatory tags for all resources
tags = {
  "environment" = "dev"
  "owner"       = "waghangad"
}