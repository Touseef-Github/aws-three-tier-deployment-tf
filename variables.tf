variable "EnvironmentName" {
  description = "An environment name that is prefixed to resource names"
  type        = string
  default     = "touseef-test"
}

variable "environment" {
  description = "An environment name that is prefixed to resource names"
  type        = string
  default     = "touseef-test"
}

variable "VpcCIDR" {
  description = "Please enter the IP range (CIDR notation) for this VPC"
  type        = string
  default     = "10.231.0.0/16"
}

variable "PublicSubnet1CIDR" {
  description = "Please enter the IP range (CIDR notation) for the public subnet in the first Availability Zone"
  type        = string
  default     = "10.231.10.0/24"
}

variable "PublicSubnet2CIDR" {
  description = "Please enter the IP range (CIDR notation) for the public subnet in the second Availability Zone"
  type        = string
  default     = "10.231.11.0/24"
}

variable "PrivateSubnet1CIDR" {
  description = "Please enter the IP range (CIDR notation) for the private subnet in the first Availability Zone"
  type        = string
  default     = "10.231.12.0/24"
}

variable "PrivateSubnet2CIDR" {
  description = "Please enter the IP range (CIDR notation) for the private subnet in the second Availability Zone"
  type        = string
  default     = "10.231.13.0/24"
}

variable "PrivateSubnet3CIDR" {
  description = "Please enter the IP range (CIDR notation) for the private subnet in the first Availability Zone"
  type        = string
  default     = "10.231.14.0/24"
}

variable "PrivateSubnet4CIDR" {
  description = "Please enter the IP range (CIDR notation) for the private subnet in the second Availability Zone"
  type        = string
  default     = "10.231.15.0/24"
}

variable "KeyPair" {
  description = "Name of the EC2 Key Pair"
  type        = string
  default     = "three-tier"
}

# variable "RDSSnapshotName" {
#   description = "Name of the RDS snapshot to restore from"
#   type        = string
# }
variable "RDSUsername" {
  description = "RDS username"
  type        = string
  default     = "admin"
}
variable "RDSPassword" {
  description = "RDS Master Root Password"
  type        = string
  default     = "S3cret%21"
}
variable "RDSInstanceName" {
  description = "Name RDS database name"
  type        = string
  default     = "my-test-db"
}