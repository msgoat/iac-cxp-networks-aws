# Setting up AWS VPCs with terraform

Creates a reference network on AWS with a VPC spanning all availability zones of the given AWS region. 

Each availability zone will host a stack of three subnets:
* one public subnet for all internet-facing resources
* one private subnet for application resources
* one private subnet for databases and messaging systems used by your applications

All outbound traffic from private resources running in the private subnets will be routed through NAT gateways 
(one NAT gateway per availability zone).
 
## Input Variables

Variable Name | Variable Type | Mandatory? | Description | Default  
 --- | --- | --- | --- | --- 
region_name | string | x | The AWS region to deploy into (e.g. eu-central-1) /
organization_name | string | x | The name of the organization that owns all AWS resources  
department_name | string | x | The name of the department that owns all AWS resources | 
project_name | string | x | The name of the project that owns all AWS resources |
stage | string | x | The name of the current environment stage |
network_name | string | x | Logical name of the VPC (will be expanded to actual VPC name "vpc-${region_name}-${network_name}") | 
network_cidr | string | x | The CIDR range of the VPC (/16 ranges recommended like "10.0.0.0/16") |  
inbound_traffic_cidrs | list(string) | x | The source IP ranges in CIDR notation allowed to access any public resource within the network. |  
eks_cluster_name | string |   | Actual name of an AWS EKS cluster, if this VPC should host an AWS EKS cluster; adds EKS support to all created VPCs and subnets | "" 

## Outputs

Output Name | Output Type | Description  
 --- | --- | ---  
network_id | string | Unique identifier of the VPC network created by this module
public_subnet_ids | list(string) | Unique identifiers of all newly created public subnets
private_subnet_ids | list(string) | Unique identifiers of all newly created private subnets
