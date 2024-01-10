resource "aws_security_group" "SSHSecurityGroup" {
  name        = "Public-Instance-Sec-Group"
  description = "Security group for SSH access"
  vpc_id      = aws_vpc.VPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.load_balancer_sg.id]
  }

  tags = {
    Name = "${var.EnvironmentName}-public-ec2"
  }
}

resource "aws_instance" "EC2Instance" {
  ami           = var.AMI
  instance_type = "t2.micro"
  key_name      = var.KeyPair
  subnet_id     = aws_subnet.PublicSubnet1.id

  security_groups = [aws_security_group.SSHSecurityGroup.id]

  tags = {
    Name = "${var.EnvironmentName}-public-ec2"
  }
}

resource "aws_eip" "NewEIP" {
  domain = "vpc"
  tags = {
    Name = "public-ec2-Instance-EIP"
  }
}

resource "aws_eip_association" "EC2InstanceEIPAssociation" {
  instance_id   = aws_instance.EC2Instance.id
  allocation_id = aws_eip.NewEIP.id
}


##############Below Will create EC2 Server in Private subnet #################


resource "aws_security_group" "SSHSecurityGroup2" {
  name        = "Private-Instance-Sec-Group"
  description = "Security group for SSH access"
  vpc_id      = aws_vpc.VPC.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.231.0.0/16"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.load_balancer_sg2.id]
  }

  tags = {
    Name = "${var.EnvironmentName}-Private-ec2"
  }
}

resource "aws_instance" "EC2Instance2" {
  ami           = var.AMI
  instance_type = "t2.micro"
  key_name      = var.KeyPair
  subnet_id     = aws_subnet.PrivateSubnet1.id

  security_groups = [aws_security_group.SSHSecurityGroup2.id]

  tags = {
    Name = "${var.EnvironmentName}-Private-ec2"
  }
}
