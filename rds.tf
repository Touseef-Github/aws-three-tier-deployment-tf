resource "aws_db_subnet_group" "RDSSubnetGroup" {
  description = "Subnet group for RDS instance"
  subnet_ids  = [
    aws_subnet.PrivateSubnet3.id,
    aws_subnet.PrivateSubnet4.id
  ]
}

resource "aws_db_instance" "RDSInstance" {
  allocated_storage    = 250
  max_allocated_storage = 500
  identifier           = var.RDSInstanceName
  instance_class       = "db.t3.small"
  engine               = "mysql"
  db_name              = var.RDSInstanceName
  username             = var.RDSUsername
  password             = var.RDSPassword
  db_subnet_group_name = aws_db_subnet_group.RDSSubnetGroup.name
  vpc_security_group_ids = [aws_security_group.RDSInstanceSecurityGroup.id]
#   snapshot_identifier = var.RDSSnapshotName
  parameter_group_name  = aws_db_parameter_group.RDSParameterGroup.name
}
resource "aws_security_group" "RDSInstanceSecurityGroup" {
  name          = "${var.RDSUsername}-Security-Group"
  description   = "${var.RDSUsername}-Security-Group"
  vpc_id        = aws_vpc.VPC.id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.231.0.0/16"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "DB-SEC-Grp"
  }
}

resource "aws_db_parameter_group" "RDSParameterGroup" {
  name        = "database-param-group"
  description = "RDS-Param-Group"
  family      = "mysql8.0" # Modify this according to your MySQL version
}