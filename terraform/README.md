# RKE2 Kubernetes Cluster Infrastructure

This Terraform module provisions AWS infrastructure for deploying an RKE2 (Rancher Kubernetes Engine 2) cluster. It creates a complete networking setup and EC2 instances ready for RKE2 installation.

## Architecture Overview

The module creates:
- **1 Master Node**: Control plane for the Kubernetes cluster
- **2 Worker Nodes**: Compute nodes for running workloads
- **Complete VPC Setup**: Isolated network environment with public subnet
- **Security Configuration**: SSH access and internet connectivity

## Infrastructure Components

### Networking
- **VPC**: `10.0.0.0/16` CIDR block in `eu-central-1` region
- **Public Subnet**: `10.0.1.0/24` with auto-assign public IPs
- **Internet Gateway**: Provides internet access
- **Route Table**: Routes traffic to internet gateway
- **Availability Zone**: `eu-central-1a`

### Compute Resources
- **3 EC2 Instances**: 1 master + 2 worker nodes
- **Instance Type**: `t3.large` (configurable)
- **AMI**: Amazon Linux 2 (configurable)
- **Public IPs**: All instances get public IP addresses

### Security
- **Security Group**: Allows SSH (port 22) from anywhere
- **Key Pair**: SSH key for instance access (must exist in AWS)

## Usage

### Prerequisites
1. AWS CLI configured with appropriate credentials
2. Terraform installed (version 0.12+)
3. EC2 Key Pair created in the target region

### Deployment Steps

1. **Initialize Terraform**:
   ```bash
   cd terraform
   terraform init
   ```

2. **Review and customize variables** (optional):
   ```bash
   # Edit terraform.tfvars or use -var flags
   terraform plan -var="key_name=your-key-name"
   ```

3. **Deploy infrastructure**:
   ```bash
   terraform apply
   ```

4. **Get instance information**:
   ```bash
   terraform output
   ```

## Configuration Variables

| Variable | Description | Type | Default | Required |
|----------|-------------|------|---------|----------|
| `ami_id` | AMI ID for EC2 instances | string | `ami-02003f9f0fde924ea` | No |
| `instance_type` | EC2 instance type | string | `t3.large` | No |
| `key_name` | EC2 key pair name for SSH access | string | `rke2-keypair` | Yes* |

*Note: The key pair must exist in your AWS account before deployment.

## Outputs

| Output | Description |
|--------|-------------|
| `instance_public_ips` | List of public IP addresses for all instances |
| `instance_names` | List of instance names (rke2-master, rke2-worker1, rke2-worker2) |

## Example Usage

### Basic Deployment
```bash
terraform apply -var="key_name=my-existing-keypair"
```

### Custom Configuration
```bash
terraform apply \
  -var="key_name=my-keypair" \
  -var="instance_type=t3.xlarge" \
  -var="ami_id=ami-0123456789abcdef0"
```

### Using terraform.tfvars
Create a `terraform.tfvars` file:
```hcl
key_name = "my-existing-keypair"
instance_type = "t3.xlarge"
ami_id = "ami-0123456789abcdef0"
```

## Post-Deployment Steps

After infrastructure is provisioned:

1. **Connect to instances**:
   ```bash
   ssh -i /path/to/your-key.pem ec2-user@<master-public-ip>
   ```

2. **Install RKE2 on master node**:
   ```bash
   curl -sfL https://get.rke2.io | sh -
   systemctl enable rke2-server.service
   systemctl start rke2-server.service
   ```

3. **Join worker nodes** using the token from master node

## Security Considerations

⚠️ **Important Security Notes**:
- SSH access is currently open to `0.0.0.0/0` (internet)
- Consider restricting SSH access to your IP range
- Review and harden security groups for production use
- Enable AWS CloudTrail for audit logging

## Cost Estimation

Approximate monthly costs (us-east-1 pricing):
- 3x t3.large instances: ~$150/month
- VPC, subnets, IGW: Free tier eligible
- Data transfer: Variable based on usage

## Cleanup

To destroy all resources:
```bash
terraform destroy
```

## Troubleshooting

### Common Issues

1. **Key pair not found**: Ensure the key pair exists in the target region
2. **AMI not available**: Update `ami_id` with a valid AMI for your region
3. **Instance limit exceeded**: Check your EC2 service limits

### Getting Help

- Check Terraform logs: `TF_LOG=DEBUG terraform apply`
- Validate configuration: `terraform validate`
- Format code: `terraform fmt`

## Contributing

When modifying this module:
1. Run `terraform fmt` to format code
2. Run `terraform validate` to check syntax
3. Test changes in a development environment first
4. Update this documentation for any changes

## License

See LICENSE file in the repository root.