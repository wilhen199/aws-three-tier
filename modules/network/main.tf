# VPC
resource "aws_vpc" "vpc_main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project_name}-vpc"
    Project     = var.project_name
    Environment = var.environment
  }
}

# Public Subnets (Application Load Balancer)
resource "aws_subnet" "subnet_public_alb" {
  count                   = 2
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index) # 10.0.0.0/16 -> 10.0.0.0/24 & 10.0.1.0/24 
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-public-alb-subnet-${count.index + 1}"
    Project     = var.project_name
    Environment = var.environment
  }
}

# Private Subnets (EC2 Instances)
resource "aws_subnet" "subnet_private_web" {
  count             = 2
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 11) # 10.0.0.0/16 -> 10.0.11.0/24 & 10.0.12.0/24 
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "${var.project_name}-private-web-subnet${count.index + 11}"
    Project     = var.project_name
    Environment = var.environment
  }

}

# Private Subnets (RDS Database)
resource "aws_subnet" "subnet_private_db" {
  count             = 2
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 21) # 10.0.0.0/16 -> 10.0.21.0/24 & 10.0.22.0/24 
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "${var.project_name}-private-db-subnet-${count.index + 21}"
    Project     = var.project_name
    Environment = var.environment
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw_main" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name        = "${var.project_name}-igw"
    Project     = var.project_name
    Environment = var.environment
  }
}

# NAT Gateway 
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet_public_alb[0].id

  tags = {
    Name        = "${var.project_name}-nat-gw"
    Project     = var.project_name
    Environment = var.environment
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name        = "${var.project_name}-nat-eip"
    Project     = var.project_name
    Environment = var.environment
  }
  depends_on = [aws_internet_gateway.igw_main]
}


# Route Table for Public Subnets
resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_main.id
  }

  tags = {
    Name        = "${var.project_name}-public-route-table"
    Project     = var.project_name
    Environment = var.environment
  }
}

# Associate Public Subnets with Route Table
resource "aws_route_table_association" "public_subnet_association" {
  count          = 2
  subnet_id      = aws_subnet.subnet_public_alb[count.index].id
  route_table_id = aws_route_table.rtb_public.id
}

# Route Table for Private Subnets Websites
resource "aws_route_table" "rtb_private_web" {
  vpc_id = aws_vpc.vpc_main.id


  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name        = "${var.project_name}-private-route-table"
    Project     = var.project_name
    Environment = var.environment
  }
}

# Associate Private Subnets Websites with Route Table
resource "aws_route_table_association" "private_web_subnet_association" {
  count          = 2
  subnet_id      = aws_subnet.subnet_private_web[count.index].id
  route_table_id = aws_route_table.rtb_private_web.id
}

resource "aws_route_table" "rtb_private_db" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name        = "${var.project_name}-private-db-route-table"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_route_table_association" "private_db_subnet_association" {
  count          = 2
  subnet_id      = aws_subnet.subnet_private_db[count.index].id
  route_table_id = aws_route_table.rtb_private_db.id
}
