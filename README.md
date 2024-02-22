# Assignment 1
# Task: Basic EC2 Instance Creation with Terraform

## Objective: In this assignment, you will create a basic Terraform configuration to provision an EC2 instance on AWS.

#### Introduction
In this task I am create VPC and then creating multiple subnets, creating s3 bucket and lauching ec2 instace in private and public subnets.

## Prerequisites:
### IAM USER:
1. Create IAM user (terraform-create-user) with access to s3, ec2 and vpc full access.
2. Generate access key for that IAM user (terraform-create-user)
3. Configure aws cli with the access key and secret access key of the user (terraform-create-user)
![iam_user_terraform_create_user.png](./images/iam_user_terraform_create_user.png)

## Requirements
| Name      | Version |
|-----------|---------|
| terraform | = 1.7.3 |
| aws 	     | = 5.37  |

## Providers:

| Name | Version |
|------|---------|
| aws  | = 5.37  |

## Backend:

**Steps to set up backend:**
   1. Create s3 bucket (jainil-terraform-assignment-2-backend) and enable versioning![s3_bucket_show_versioning.png](./images/s3_bucket_show_versioning.png)
   2. Create DynamoDB Table (jainil-terraform-lock-table) with partition key named LockID and type String.![dynamo_db_show_pk.png](./images/dynamo_db_show_pk.png)
   3. Create Policy (S3_w_r_t) give access to `s3:ListBucket`, `s3:GetObject` and `s3:PutObject` and set resource as bucket's arn.![S3_w_r_t_show_permissions.png](./images/S3_w_r_t_show_permissions.png)![s3_w_r_t_json.png](./images/s3_w_r_t_json.png)
   4. Create Policy (Dynamo_w_r_t) give access to `dynamodb:DescribeTable`, `dynamodb:GetItem` and `dynamodb:PutItem` and `dynamodb:DeleteItem` and set resource as dynamoDB table's arn.![Dynamo_w_r_t_show_permissions.png](./images/Dynamo_w_r_t_show_permissions.png)![Dynamo_w_r_t_json.png](./images/Dynamo_w_r_t_json.png)
   5. Create New Role (named terraform) and attach 2 policies (Dynamo_w_r_t and S3_w_r_t) created in the previous step.![terraform_role_show_policies.png](terraform_role_show_policies.png)
   6. Now create a new Policy (Allow-Terraform) and provide allow it to assume role of terraform.![Allow_terraform_json.png](Allow_terraform_json.png)
   7. Now create a new User-group (named terraform-access) and attach policy (Allow-Terraform) created in the previous step.![terraform-access-permissions.png](terrafom-access-permissions.png)
   8. Now create a new user (named terra-user) and add it to user group (terraform-access) created in previous step.![terra-user_show_group.png](./images/terra-user_show_group.png)


## Backend config in main.tf:

| Name           | Value                                      |
|----------------|--------------------------------------------|
| bucket         | "jainil-terraform-assignment-2-backend"    |
| region         | "ap-south-1"                               |
| encrypt        | true                                       |
| profile        | "terra-user"                               |
| role_arn       | "arn:aws:iam::171358186705:role/terraform" |
| dynamodb_table | "jainil-terraform-lock-table"              |
| key            | "assignment-1/test/terraform.tfstate"      |


## VPC Module:

### Resources:

| Name                        | Type     |
|-----------------------------|----------|
| aws_internet_gateway        | Resource |
| aws_route_table_association | Resource |
| aws_route_table             | Resource |
| aws_subnet                  | Resource |
| aws_vpc                     | Resource |

### Variables:

| Name                       | Description                        | type           | Default          |
|----------------------------|------------------------------------|----------------|------------------|
| env                        | Environment Name                   | `string`       | No Default Value |
| vpc_cidr_block             | VPC's cidr block                   | `string`       | `10.0.0.0/16`    |
| azs                        | List of Availability zones         | `string`       | No Default Value |
| private_subnet_cidr_blocks | List of private subnets cidr block | `list(string)` | `[]`             |
| public_subnet_cidr_blocks  | List of public subnets cidr block  | `list(string)` | `[]`             |
| public_subnet_tags         | Public subnet tags                 | `map(any)`     | `{}`             |
| private_subnet_tags        | Private subnet tags                | `map(any)`     | `{}`             |

### Outputs:

| Name                   | Description                |
|------------------------|----------------------------|
| private_subnet_ids     | List of private subnet IDs |
| public_subnet_ids      | List of public subnet IDs  |
| vpc_id                 | VPC ID                     |
| igw_id                 | Internet Gateway ID        |
| private_route_table_id | Private route table ID     |
| public_route_table_id  | Public route table ID      |

## Instances Module:

### Resources:

| Name                    | Type     |
|-------------------------|----------|
| aws_instance            | Resource | 
| aws_key_pair            | Resource |
| aws_security_group_rule | Resource |
| aws_security_group      | Resource |

### Variables:

| Name                                | Description                                                                                                               | type                                                                                                                                                                                                              | Default                                                                                                                                                                     |
|-------------------------------------|---------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| env                                 | Environment Name                                                                                                          | `string`                                                                                                                                                                                                          | No Default Value                                                                                                                                                            |
| ami_id                              | AMI ID for instance                                                                                                       | `string`                                                                                                                                                                                                          | No Default Value                                                                                                                                                            |
| instance_type                       | Instance type of instance                                                                                                 | `string`                                                                                                                                                                                                          | `t2.micro`                                                                                                                                                                  |
| private_subnet_ids                  | List of private subnet ids                                                                                                | `list(string)`                                                                                                                                                                                                    | No Default Value                                                                                                                                                            |
| public_subnet_ids                   | List of public subnet ids                                                                                                 | `list(string)`                                                                                                                                                                                                    | No Default Value                                                                                                                                                            |
| vpc_id                              | VPC ID                                                                                                                    | `string`                                                                                                                                                                                                          | No Default Value                                                                                                                                                            |
| public_sg_ingress_with_cidr_blocks  | Full ingress blocks with cidr blocks, to_port, from_port, protocol, ipv6_cidr_blocks(optional) for public security group  | <pre> list(object({ <br/>&emsp;from_port = number<br/>&emsp;to_port = number <br/>&emsp;protocol = string<br/>&emsp;cidr_blocks = list(string)<br/>&emsp;ipv6_cidr_blocks = optional(list(string))<br/>})) </pre> | `[]`                                                                                                                                                                        | 
| public_sg_egress_with_cidr_blocks   | Full egress blocks with cidr blocks, to_port, from_port, protocol, ipv6_cidr_blocks(optional) for public security group   | <pre> list(object({ <br/>&emsp;from_port = number<br/>&emsp;to_port = number <br/>&emsp;protocol = string<br/>&emsp;cidr_blocks = list(string)<br/>&emsp;ipv6_cidr_blocks = optional(list(string))<br/>})) </pre> | <pre>[{<br/>&emsp;from_port= 0<br/>&emsp;to_port = 0 <br/>&emsp;protocol = "-1" <br/>&emsp;cidr_blocks = ["0.0.0.0/0"] <br/>&emsp;ipv6_cidr_blocks = ["::/0"]<br/>}] </pre> |
| private_sg_ingress_with_cidr_blocks | Full ingress blocks with cidr blocks, to_port, from_port, protocol, ipv6_cidr_blocks(optional) for private security group | <pre> list(object({ <br/>&emsp;from_port = number<br/>&emsp;to_port = number <br/>&emsp;protocol = string<br/>&emsp;cidr_blocks = list(string)<br/>&emsp;ipv6_cidr_blocks = optional(list(string))<br/>})) </pre> | `[]`                                                                                                                                                                        |
| private_sg_egress_with_cidr_blocks  | Full egress blocks with cidr blocks, to_port, from_port, protocol, ipv6_cidr_blocks(optional) for private security group  | <pre> list(object({ <br/>&emsp;from_port = number<br/>&emsp;to_port = number <br/>&emsp;protocol = string<br/>&emsp;cidr_blocks = list(string)<br/>&emsp;ipv6_cidr_blocks = optional(list(string))<br/>})) </pre> | `[]`                                                                                                                                                                        |

### Outputs:

| Name                | Description               |
|---------------------|---------------------------|
| private_sg_id       | Private security group id |
| public_sg_id        | Public security group id  |
| public_instance_id  | Public ec2 instance id    |
| private_instance_id | Private ec2 instance id   |

## main.tf Configurations:

### Local Variables:

| Name | Value  |
|------|--------|
| env  | `test` |

### VPC Inputs:

| Name                       | Input               |
|----------------------------|---------------------|
| env                        | `local.env`         |
| azs                        | `["ap-south-1a"]`   |
| vpc_cidr_block             | `"77.23.0.0/16" `   |
| private_subnet_cidr_blocks | `["77.23.0.64/26"]` |
| public_subnet_cidr_blocks  | `["77.23.2.64/26"]` |
| private_subnet_tags        | `{}`                |
| public_subnet_tags         | `{}`                |


### Instances Inputs:

| Name                               | Input                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
|------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| env                                | `local.env`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ami_id                             | `"ami-06b72b3b2a773be2b"`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| instance_type                      | `"t2.micro"`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| private_subnet_ids                 | `module.vpc.private_subnet_ids `                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| public_subnet_ids                  | `module.vpc.public_subnet_ids`                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| vpc_id                             | `module.vpc.vpc_id`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| public_sg_ingress_with_cidr_blocks | <pre>public_sg_ingress_with_cidr_blocks = [<br>{<br/>&emsp;from_port=22<br/>&emsp;to_port=22<br/>&emsp;protocol="tcp"<br/>&emsp;cidr_blocks=["120.42.44.12/32"]<br/>},<br>{<br/>&emsp;from_port=80<br>&emsp;to_port = 80<br>&emsp;protocol = "tcp"<br>&emsp;cidr_blocks = ["0.0.0.0/0"]<br>&emsp;ipv6_cidr_blocks=["::/0"]<br>},<br/>{<br/>&emsp;from_port=443<br/>&emsp;to_port=443<br/>&emsp;protocol="tcp"<br/>&emsp;cidr_blocks=["0.0.0.0/0"]<br/>&emsp;ipv6_cidr_blocks=["::/0"]<br/>&emsp;}<br>]</pre> |


## **Terraform steps:**
1. **`terraform init` :** The `terraform init` command initializes a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control.

   ![terraform_init_result.png](./images/terraform_init_result.png)

2. **`terraform plan`:** The `terraform plan` command creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure. By default, when Terraform creates a plan it:
- Reads the current state of any already-existing remote objects to make sure that the Terraform state is up-to-date.
- Compares the current configuration to the prior state and noting any differences.
- Proposes a set of change actions that should, if applied, make the remote objects match the configuration.

  ![terraform_plan_result_1.png](./images/terraform_plan_result_1.png)
  ![terraform_plan_result_2.png](./images/terraform_plan_result_2.png)
  ![terraform_plan_result_3.png](./images/terraform_plan_result_3.png)
  ![terraform_plan_result_4.png](./images/terraform_plan_result_4.png)
  ![terraform_plan_result_5.png](./images/terraform_plan_result_5.png)

3. **`terraform apply`:** The `terraform apply` command executes the actions proposed in a Terraform plan.

   ![terraform_apply_result_1.png](./images/terraform_apply_result_1.png)
   ![terraform_apply_result_2.png](./images/terraform_apply_result_2.png)
   ![terraform_apply_aws_vpc.png](./images/terraform_apply_aws_vpc.png)
   ![terraform_apply_aws_ec2.png](./images/terraform_apply_aws_ec2.png)

   **backend:**
   ![backedn_s3_bucket](./images/backend_s3_bucket_ass1.png)
