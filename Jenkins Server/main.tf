#VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkins-vpc"
  cidr = var.vpc_cidr

  azs                  = data.aws_availability_zones.available.names
  public_subnets       = var.public_subnet
  enable_dns_hostnames = true

  tags = {
    Name        = "jenkins-vpc"
    Terraform   = "true"
    Environment = "dev"
  }
  public_subnet_tags = {
    Name="Jenkins-subnet"
  }
  public_route_table_tags = {
    Name="Jenkins-RT"
  }
}



#SG
module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "jenkins-SG"
  description = "SQL publicly open"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks      = ["10.10.0.0/16"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 9000
      to_port     = 9000
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
    
  ]
  egress_with_cidr_blocks = [
    {
        from_port = 0
        to_port = 0
        protocol= "-1"
        cidr_blocks = "0.0.0.0/0"
    }
  ]
  tags = {
    Name = "Jenkins-SG"
  }
}

#EC2
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  instance_type          = var.instance_type
  key_name               = "myKeyPair"
  monitoring             = true
  vpc_security_group_ids = [module.sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data = file("./jenkins-install.sh")
  ami = data.aws_ami.amazon-2.id
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name="Jenkins-Server"
    Terraform   = "true"
    Environment = "dev"
  }
}
module "sonar_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  instance_type          = var.instance_type
  key_name               = "myKeyPair"
  monitoring             = true
  vpc_security_group_ids = [module.sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data = <<EOF
  #!/bin/bash
sudo yum update -y
sudo yum upgrade -y
sudo yum install java-17-amazon-corretto -y

sudo amazon-linux-extras install docker -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -a -G docker ec2-user

sudo docker run --name sonar -d -p 9000:9000 sonarqube:lts-community

  EOF
  ami = data.aws_ami.amazon-2.id
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name="Sonar-Server"
    Terraform   = "true"
    Environment = "dev"
  }
}