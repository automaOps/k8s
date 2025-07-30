variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-02003f9f0fde924ea" # Amazon Linux 2 AMI (example, check latest)
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t3.large"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = "rke2-keypair"
}
