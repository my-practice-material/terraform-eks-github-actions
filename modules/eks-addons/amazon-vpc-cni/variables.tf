variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)
  default     = {}
}

variable "aws_iam_openid_connect_provider_arn" {
  type        = string
  description = "ARN of the AWS IAM OpenID Connect provider for the EKS cluster"
  default     = ""
}

variable "vpc_cni_addon_version" {
  description = "The version of the Amazon VPC CNI addon to use for the EKS cluster"
  type        = string
  default     = "v1.21.1-eksbuild.1"  
}

variable "secondary_pod_subnet_az1" {
  description = "The ID of the secondary subnet for pods in availability zone 1"
  type        = string
  default     = ""
}

variable "secondary_pod_subnet_az2" {
  description = "The ID of the secondary subnet for pods in availability zone 2"
  type        = string
  default     = ""
}

variable "secondary_pod_subnet_az1_name" {
  description = "The name of the secondary subnet for pods in availability zone 1"
  type        = string
  default     = ""
}

variable "secondary_pod_subnet_az2_name" {
  description = "The name of the secondary subnet for pods in availability zone 2"
  type        = string
  default     = ""
}

variable "node_security_groups" {
  description = "List of security group IDs to associate with the secondary pod subnets"
  type        = list(string)
  default     = []
}