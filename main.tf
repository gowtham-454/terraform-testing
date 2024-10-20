# data "vault_kv_secret_v2" "aws-auth" {
#   mount = "kv"
#   name  = "aws-cred"
# }

# provider "aws" {
#   region     = var.aws_region
#   access_key = data.vault_kv_secret_v2.aws-auth.data["accesskey"]
#   secret_key = data.vault_kv_secret_v2.aws-auth.data["secretkey"]
# }




# #####################################################################
#creating a VPC named TEST_VPC

resource "aws_vpc" "TEST_VPC" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "TEST_VPC"
  }
}

#creating an internet gateway named TEST_InternetGateway for TEST_VPC

resource "aws_internet_gateway" "TEST_igw" {
  vpc_id = aws_vpc.TEST_VPC.id

  tags = {
    Name = "TEST_Internet_Gateway"
  }
}

#creating Public subnets for TEST_VPC

resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.TEST_VPC.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)

  map_public_ip_on_launch = true

  tags = {
    Name = "TEST_Public_Subnet-${count.index + 1}"
  }
}

#creating Private subnets for TEST_VPC

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.TEST_VPC.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)

  map_public_ip_on_launch = false

  tags = {
    Name = "TEST_Private_Subnet-${count.index + 1}"
  }
}

# create a Public route table

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.TEST_VPC.id

  route {
    cidr_block                = "0.0.0.0/0"
    gateway_id                = aws_internet_gateway.TEST_igw.id
  }

  tags = {
    Name = "TEST_Public_Route_Table"
  }
}

# create a Private route table

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.TEST_VPC.id

  tags = {
    Name = "TEST_Private_Route_Table"
  }
}

#public routing

resource "aws_route_table_association" "public_association" {
  count             = length(aws_subnet.public_subnet)
  subnet_id         = aws_subnet.public_subnet[count.index].id
  route_table_id    = aws_route_table.public_route_table.id
}

#Private routing

resource "aws_route_table_association" "private_association" {
  count             = length(aws_subnet.private_subnet)
  subnet_id         = aws_subnet.private_subnet[count.index].id
  route_table_id    = aws_route_table.private_route_table.id
}

#create a security group

resource "aws_security_group" "SG1" {
  name        = "SG_TEST_VPC"
  description = "Security group to allow SSH and TCP traffic"
  vpc_id      = aws_vpc.TEST_VPC.id  # Reference your existing VPC

  ingress {
    from_port   = 22   # Allow SSH access
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change this to restrict access as needed
  }

  ingress {
    from_port   = 80   # Allow HTTP traffic
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP from anywhere
  }

  ingress {
    from_port   = 443  # Allow HTTPS traffic
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTPS from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TEST_SG1"
  }
}

 resource "aws_instance" "TEST_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  availability_zone = "us-east-1a"
  subnet_id     = aws_subnet.public_subnet[0].id
  key_name      = "MY-KEY-PAIR-1"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.SG1.id] # Use the new security group

  

  tags = {
        Name = var.Instance_name
        Env = "UAT"
        Owner = "Gowtham"
	    CostCenter = "C1"
    }

  lifecycle {
    ignore_changes = [
      associate_public_ip_address,
      instance_state,
    ]
  }
}

resource "aws_instance" "Vault-Server" {
  ami           = var.vault_ami_id
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  subnet_id     = var.vault_subnet
  key_name      = "MY-KEY-PAIR-1"
  associate_public_ip_address = true
  vpc_security_group_ids = var.Vault_SG
  

  tags = {
        Name = "vault"
        Env = "UAT"
        Owner = "Gowtham"
	    CostCenter = "C1"
    }
	lifecycle {
    ignore_changes = [
      associate_public_ip_address,
      instance_state,
    ]
  }
}

