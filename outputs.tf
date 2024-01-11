output "VPC" {
  description = "A reference to the created VPC"
  value       = aws_vpc.VPC.id
}

output "PublicSubnet1" {
  description = "A reference to the public subnet in the 1st Availability Zone"
  value       = aws_subnet.PublicSubnet1.id
}

output "PublicSubnet2" {
  description = "A reference to the public subnet in the 2nd Availability Zone"
  value       = aws_subnet.PublicSubnet2.id
}

output "PrivateSubnet1" {
  description = "A reference to the private subnet in the 1st Availability Zone"
  value       = aws_subnet.PrivateSubnet1.id
}

output "PrivateSubnet2" {
  description = "A reference to the private subnet in the 2nd Availability Zone"
  value       = aws_subnet.PrivateSubnet2.id
}

output "PrivateSubnet3" {
  description = "A reference to the private subnet in the 1st Availability Zone"
  value       = aws_subnet.PrivateSubnet3.id
}

output "PrivateSubnet4" {
  description = "A reference to the private subnet in the 2nd Availability Zone"
  value       = aws_subnet.PrivateSubnet4.id
}

#########EC2 Public instance web server outputs ###########
output "ec2_instance_id" {
  value = aws_instance.EC2Instance.id
}

output "ec2_instance_security_group_id" {
  value = aws_security_group.SSHSecurityGroup.id
}

output "ec2_instance_eip" {
  value = aws_eip.NewEIP.public_ip
}

########EC2 private app server outputs##########
output "private_ec2_instance_id" {
  value = aws_instance.EC2Instance2.id
}

output "private_ec2_instance_security_group_id" {
  value = aws_security_group.SSHSecurityGroup2.id
}

#########RDS Out puts#######
output "rds_instance_endpoint" {
  value = aws_db_instance.RDSInstance.endpoint
}

output "rds_instance_address" {
  value = aws_db_instance.RDSInstance.address
}

output "rds_instance_port" {
  value = aws_db_instance.RDSInstance.port
}

##########Load balancers output dnd##############
output "alb_dns_name_web" {
  value = aws_lb.web.dns_name
}

output "alb_dns_name_app" {
  value = aws_lb.app-lb.dns_name
}

# output "NoIngressSecurityGroup" {
#   description = "Security group with no ingress rule"
#   value       = aws_security_group.NoIngressSecurityGroup.id
# }

output "S3_bucket_arn1" {
  value = aws_s3_bucket.storage_bucket.arn
}

output "S3_bucket_arn2" {
  value = aws_s3_bucket.storage_bucket2.arn
}