#
# AWS
#

variable "aws_tags" {
  type    = map(string)
  default = {}
}

variable "vpc_cidr_block" {
  type    = string
}

variable "num_subnets" {
  type    = number
  default = "2"
}

variable "provider_region" {
  type    = string
  default = "ap-northeast-1"
}

variable "aws_access_key" {
  type    = string
}

variable "aws_secret_key" {
  type    = string
}

variable "vpc_name" {
  type    = string
}

#
# EKS
#

variable "cluster_name" {
  type    = string
}

variable "cluster_version" {
  type    = string
  default = "1.30"
}

variable "node_group_name" {
  type    = string
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.micro"]
}

variable "node_desired_size" {
  type    = number
}

variable "node_max_size" {
  type    = number
}

variable "node_min_size" {
  type    = number
}

#
# kubectl instance
#

variable "instance_iam_instance_profile_name" {
  type    = string
  default = "kubectl_instance_iam_instance_profile"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "instance_subnet_cidr_block" {
  type    = string
  default = "10.0.10.0/24"
}

variable "instance_kubectl_install_url" {
  type    = string
  default = "https://s3.us-west-2.amazonaws.com/amazon-eks/1.27.6/2023-10-17/bin/linux/amd64/kubectl"
}

variable "instance_kubectl_sha_install_url" {
  type    = string
  default = "https://s3.us-west-2.amazonaws.com/amazon-eks/1.27.6/2023-10-17/bin/linux/amd64/kubectl.sha256"
}

#
# RDS
#

variable "rds_db_name" {
  type    = string
}
variable "rds_user_name" {
  type    = string
}
variable "rds_password" {
  type    = string
}

#
# Redis
#

variable "redis_cluster_id" {
  type     = string
}

#
# Route53
#

variable "host_domain" {
  type     = string
}

variable "app_domain_name" {
  type     = string
}