variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]  # CIDRs for two public subnets
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]  # CIDRs for two private subnets
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]  # Specify your desired availability zones
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.nano"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-005fc0f236362e99f"  
}

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  default     = "us-east-1"  # Change to your preferred region
}

variable "Instance_name" {
  description = "Instance name"
  default     = "manually_edited"
}
### vault variables #######

variable "vault_ami_id" {
  description = "AMI ID for the Vault Server"
  default     = "ami-0866a3c8686eaeeba" 
}

variable "vault_subnet" {
  description = "subnet ID for the Vault Server"
  default     = "subnet-078d6ba8f1db5f2c0"
}

variable "Vault_SG" {
  type = list(string)
  default = ["sg-074583d20e8db5a70"]  # Example: replace with your actual security group ID
}