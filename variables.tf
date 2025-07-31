# Region and AZ configuration
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# Project naming
variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "web-app-infrastructure"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

# Network configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

# # Instance configuration
# variable "instance_type" {
#   description = "EC2 instance type"
#   type        = string
#   default     = "t2.micro"
# }

# variable "min_size" {
#   description = "Minimum number of instances in ASG"
#   type        = number
#   default     = 2
# }

# variable "max_size" {
#   description = "Maximum number of instances in ASG"
#   type        = number
#   default     = 4
# }

# variable "desired_capacity" {
#   description = "Desired number of instances in ASG"
#   type        = number
#   default     = 2
# }

# # Database configuration
# variable "db_instance_class" {
#   description = "RDS instance class"
#   type        = string
#   default     = "db.t2.micro"
# }

# variable "db_name" {
#   description = "Database name"
#   type        = string
#   default     = "webappdb"
# }

# variable "db_username" {
#   description = "Database username"
#   type        = string
#   default     = "admin"
# }

# variable "db_password" {
#   description = "Database password"
#   type        = string
#   sensitive   = true
# }