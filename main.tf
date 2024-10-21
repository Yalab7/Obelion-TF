resource "aws_vpc" "obelion_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev-vpc"
  }
}

resource "aws_subnet" "obelion_public_subnet1" {
  vpc_id                  = aws_vpc.obelion_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone_id    = "eun1-az1"

  tags = {
    Name = "dev-public1"
  }
}

resource "aws_subnet" "obelion_public_subnet2" {
  vpc_id                  = aws_vpc.obelion_vpc.id
  cidr_block              = "10.123.2.0/24"
  map_public_ip_on_launch = true
  availability_zone_id    = "eun1-az2"

  tags = {
    Name = "dev-public2"
  }
}

resource "aws_internet_gateway" "obelion_internet_gateway" {
  vpc_id = aws_vpc.obelion_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "obelion_public_rtb" {
  vpc_id = aws_vpc.obelion_vpc.id
  tags = {
    Name = "dev-public-rtb"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.obelion_public_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.obelion_internet_gateway.id
}

resource "aws_route_table_association" "obelion_public_association" {
  subnet_id      = aws_subnet.obelion_public_subnet1.id
  route_table_id = aws_route_table.obelion_public_rtb.id
}

resource "aws_key_pair" "ssh_auth" {
  key_name   = "sshkey"
  public_key = file("~/.ssh/sshkey.pub")
}

resource "aws_instance" "frontend_ec2" {
  instance_type = "t3.micro"
  ami           = data.aws_ami.server_ami.id

  tags = {
    Name = "Frontend"
  }

  key_name               = aws_key_pair.ssh_auth.id
  vpc_security_group_ids = [aws_security_group.frontend_backend_sg.id]
  subnet_id              = aws_subnet.obelion_public_subnet1.id

  root_block_device {
    volume_size = 8
  }
}

resource "aws_instance" "backend_ec2" {
  instance_type = "t3.micro"
  ami           = data.aws_ami.server_ami.id

  tags = {
    Name = "Backend"
  }

  key_name               = aws_key_pair.ssh_auth.id
  vpc_security_group_ids = [aws_security_group.frontend_backend_sg.id]
  subnet_id              = aws_subnet.obelion_public_subnet1.id

  root_block_device {
    volume_size = 8
  }
}

resource "aws_db_instance" "mysql" {
  engine              = "mysql"
  instance_class      = "db.t3.micro"   # Free tier instance class
  allocated_storage   = 20              # Minimum allowed storage
  db_name             = "mysqldb"       # Database name
  username            = "admin"         # Master username
  password            = var.db_password # Master password
  engine_version      = "8.0.39"        # MySQL version
  publicly_accessible = false           # No public internet access
  skip_final_snapshot = true            # Skip snapshot when terminating
  storage_type        = "gp3"           # General Purpose SSD
  multi_az            = false           # No multi-AZ deployment

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet.id

  tags = {
    Name = "mysql-rds"
  }
}

resource "aws_db_subnet_group" "rds_subnet" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.obelion_public_subnet1.id, aws_subnet.obelion_public_subnet2.id]

  tags = {
    Name = "rds-subnet-group"
  }
}