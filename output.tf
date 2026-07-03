# This file is used to define the output variables for the Terraform configuration.

output "vpc_id" {
  description = "The ID of the created VPC."
  value       = module.create_vpc.vpc_id
}

# output "aws_iam_role" {
#   description = "OIDC role for GitHub Action Deployments"
#   value = module.create_eks_standard_cluster.oidc_role_arn
# }

# output "ecr_repo_name" {
#   value = module.create_ecr_repo.ecr_repo_name
#   description= "ECR private repository name."
# }