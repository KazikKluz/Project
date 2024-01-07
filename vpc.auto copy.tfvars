# VPC Variables
# VPC Input Variables

vpc_name = "myvpc"

vpc_cidr_block = "10.0.0.0/16"

# vpc_availability_zones = ["eu-west-1a", "eu-west-1b"]

vpc_public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

vpc_private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

vpc_database_subnets = ["10.0.151.0/24", "10.0.152.0/24"]

vpc_create_database_subnet_group = true

# VPC Create Database Subnet Route Table (True / False)
vpc_create_database_subnet_route_table = true

# VPC Enable NAT Gateway (True / False)
vpc_enable_nat_gateway = true

# VPC Single NAT Gatway (True / False)
vpc_single_nat_gateway = true
