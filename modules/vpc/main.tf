# Create VPC with public and private subnets, seperate route tables for private subnets.
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.1"
  name = var.vpc_name
  cidr = var.vpc_cidr
  secondary_cidr_blocks = var.secondary_cidr_blocks
  azs = var.azs
  private_subnets = var.private_subnets
  private_subnet_names = var.private_subnet_names
  public_subnets = var.public_subnets
  public_subnet_names = var.public_subnet_names
  map_public_ip_on_launch = true
  enable_dns_hostnames = true
  enable_dns_support = true   
  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared" # IMP This tag is required for EKS to recognize the private subnets as part of the cluster and use them for provisioning worker nodes. The value can be "shared" or "owned" depending on whether the subnets are shared with other clusters or owned by this cluster.
  }
  public_subnet_tags = {
    "karpenter.sh/discovery" = var.cluster_name # IMP This tag is required for Karpenter to discover the public subnets and use them for provisioning nodes if needed. The value should match the cluster name.
  }
  tags = var.tags
}



# Create security group for VPC Interface Endpoints
module "vpc_endpoints_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.0.0"
  name        = "vpc-endpoints-interface-sg"
  description = "Security group for VPC Interface Endpoints"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

# Create VPC Endpoints for ECR API, ECR DKR, EKS, STS and S3.
# module "vpc_endpoints" {
#   source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
#   version = "6.6.1"
#   vpc_id = module.vpc.vpc_id
#   endpoints = {
#     ecr_api = {
#         service = "ecr.api"
#         service_type    = "Interface"
#         private_dns_enabled = true # IMP Enable private DNS for the endpoint, so that calls to ecr.api will resolve to the endpoint's private IPs else they will go to the public endpoint and fail to pull images since the VPC does not have internet access
#         subnet_ids        = [
#           module.vpc.private_subnets[0], # us-east-1a
#           module.vpc.private_subnets[1], # us-east-1b
#         ]
#         security_group_ids = [module.vpc_endpoints_security_group.security_group_id]
#         tags            = { Name = "ecr-api-interface-endpoint" }
#     },
#     ecr_dkr = {
#         service = "ecr.dkr"
#         service_type    = "Interface"
#         private_dns_enabled = true
#         subnet_ids        = [
#           module.vpc.private_subnets[0], # us-east-1a
#           module.vpc.private_subnets[1], # us-east-1b
#         ]
#         security_group_ids = [module.vpc_endpoints_security_group.security_group_id]
#         tags            = { Name = "ecr-dkr-interface-endpoint" }
#     },
#     eks = {
#         service = "eks"
#         service_type    = "Interface"
#         private_dns_enabled = true
#         subnet_ids        = [
#           module.vpc.private_subnets[0], # us-east-1a
#           module.vpc.private_subnets[1], # us-east-1b
#         ]
#         security_group_ids = [module.vpc_endpoints_security_group.security_group_id]
#         tags            = { Name = "eks-interface-endpoint" }
#     },
#     sts = {
#         service = "sts"
#         service_type    = "Interface"
#         private_dns_enabled = true
#         subnet_ids        = [
#           module.vpc.private_subnets[0], # us-east-1a
#           module.vpc.private_subnets[1], # us-east-1b
#         ]
#         security_group_ids = [module.vpc_endpoints_security_group.security_group_id]
#         tags            = { Name = "sts-interface-endpoint" }
#     },
#     s3 = {
#         service = "s3"
#         service_type    = "Gateway"
#         route_table_ids = module.vpc.private_route_table_ids
#         tags            = { Name = "s3-gateway-endpoint" }
#     }
#   } 
# }