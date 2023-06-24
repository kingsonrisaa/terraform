
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc-${var.environment}"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


resource "aws_security_group" "clumsy_bird" {
  description = "Clumsy Bird Security Group Access"
  name        = "${var.prefix}-security-group"

  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8001
    to_port     = 8001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-security-group"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_eip" "clumsy_bird" {
  instance = aws_instance.clumsy_bird.id
  domain      = "vpc"
  tags = {
    "Name" = "${var.prefix}-${var.project}-${var.environment}"
  }
}

resource "aws_eip_association" "clumsy_bird" {
  instance_id   = aws_instance.clumsy_bird.id
  allocation_id = aws_eip.clumsy_bird.id
}

resource "aws_instance" "clumsy_bird" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids      = [aws_security_group.clumsy_bird.id]

  user_data = templatefile("${path.module}/files/deploy_app.sh", {})

  tags = {
    Name = "${var.prefix}-${var.project}-${var.environment}-instance"
  }
}
