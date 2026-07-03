# This file is used to define the input variables for the Terraform configuration.

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
  default     = "study-vpc"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.10.0.0/20"
} 

variable "secondary_cidr_blocks" {
  type        = list(string)
  description = "List of secondary CIDR blocks for the VPC"
  default     = ["100.64.0.0/16"]
}

variable "azs" {
  type        = list(string)
  description = "List of Availability Zones to use for subnets"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "elb_public_subnets" {
  type        = list(string)
  description = "List of CIDR blocks for public subnets"
  default     = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "elb_public_subnets_names" {
  type        = list(string)
  description = "List of names for public subnets"
  default     = ["study-vpc-elb-pub-sbnt-az1", "study-vpc-elb-pub-sbnt-az2"]

}

variable "app_private_subnets" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets for application servers"
  default     = ["10.10.3.0/24", "10.10.4.0/24"]
}

variable "app_private_subnet_names" {
  type        = list(string)
  description = "List of names for private subnets for application servers"
  default     = ["study-vpc-app-priv-sbnt-az1", "study-vpc-app-priv-sbnt-az2"] 
}

variable "db_private_subnets" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets for database servers"
  default     = ["10.10.5.0/24", "10.10.6.0/24"]
}

variable "db_private_subnet_names" {
  type        = list(string)
  description = "List of names for private subnets for database servers"
  default     = ["study-vpc-db-priv-sbnt-az1", "study-vpc-db-priv-sbnt-az2"]  
}

variable "eks_cluster_name" {
  type        = string
  description = "Name of the EKS Cluster"
  default     = "study-eks-cluster" 
}

variable "worker_node_name" {
  type        = string
  description = "Name of worker node"
  default     = "study-worker-node"
}

variable "karpenter_controller_node_name" {
  type        = string
  description = "Name of Karpenter controller node"
  default     = "karpenter-controller-node"
}

variable "karpenter_worker_node_name" {
  type        = string
  description = "Name of Karpenter worker node"
  default     = "karpenter-worker-node"
}

variable "node_group_desired_capacity" {
  type        = number
  description = "Desired capacity of Node Group ASG."
  default     = 1
}

variable "node_group_min_size" {
  type        = number
  description = "Minimum size of Node Group ASG."
  default     = 1
}

variable "node_group_max_size" {
  type        = number
  description = "Maximum size of Node Group ASG. Set to at least 1 greater than node_group_desired_capacity."
  default     = 2
}

variable "cluster_admin_role_arn" {
  type        = string
  description = "ARN of the IAM Role to be used as EKS Cluster admin. This role will be granted the AmazonEKSClusterAdminPolicy managed policy and added to the aws-auth configmap for cluster admin access."
  default     = "arn:aws:iam::360496493435:role/aws-reserved/sso.amazonaws.com/ap-south-1/AWSReservedSSO_AdministratorAccess"
}

variable "vpc_cni_addon_version" {
  description = "The version of the Amazon VPC CNI addon to use for the EKS cluster"
  type        = string
  default     = "v1.21.1-eksbuild.1"        
}

variable "coredns_addon_version" {
  description = "The version of the CoreDNS addon to use for the EKS cluster"
  type        = string
  default     = "v1.13.2-eksbuild.4"
}

variable "matrix_server_version" {
  description = "The version of the metrics-server addon to use for the EKS cluster"
  type        = string
  default     = "v0.8.1-eksbuild.6"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to all resources."
  default     = {
    "environment" = "dev"
    "owner"       = "Angad Wagh"
  } 
}

variable "ecr_repo_name" {
  type = string
  description = "ECR repository name"
  default = "study/study-ecr-repo"
}

variable "secondary_pod_subnet_az1_name" {
  description = "The name of the secondary subnet for pods in availability zone 1"
  type        = string
  default     = "study-vpc-pod-priv-sbnt-az1"
}

variable "secondary_pod_subnet_az2_name" {
  description = "The name of the secondary subnet for pods in availability zone 2"
  type        = string
  default     = "study-vpc-pod-priv-sbnt-az2"
}