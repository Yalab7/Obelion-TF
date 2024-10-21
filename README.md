# Terraform AWS Infrastructure for the Cloud Automation Assessment

This project automates the deployment of an e-commerce application infrastructure using Terraform. The architecture includes:
- **Node.js Frontend**: Deployed on an EC2 instance with public access.
- **Laravel Backend (PHP)**: Deployed on another EC2 instance with public access.
- **MySQL RDS**: A MySQL database (version 8) hosted on AWS RDS, with no public exposure.

## Project Structure

The Terraform configuration is divided into logical components, with each file managing specific resources or configurations. Below is an overview of the file structure and what each file is responsible for.

### File Structure

```bash
/terraform
  ├── main.tf                 # Core infrastructure resources (EC2 instances, RDS, etc.)
  ├── provider.tf             # AWS provider and region setup
  ├── variables.tf            # Input variables for infrastructure configuration
  ├── outputs.tf              # Outputs such as EC2 public IPs and RDS endpoints
  ├── security-groups.tf      # Security group configurations for EC2 and RDS
