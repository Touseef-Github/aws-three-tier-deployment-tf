RDSInstanceName             =  "database1"
RDSPassword                 =  "S3cret%21"
RDSUsername                 =  "admin"
KeyPair                     =  "three-tier"
VpcCIDR                     =  "10.231.0.0/16"
PrivateSubnet1CIDR          =  "10.231.12.0/24"
PrivateSubnet2CIDR          =  "10.231.13.0/24"
PrivateSubnet3CIDR          =  "10.231.14.0/24"
PrivateSubnet4CIDR          =  "10.231.15.0/24"
PublicSubnet1CIDR           =  "10.231.10.0/24"
PublicSubnet2CIDR           =  "10.231.11.0/24"
EnvironmentName             =  "touseef-test-network"
environment                 =  "test-Touseef"
AMI                         =  "ami-079db87dc4c10ac91"
# CustomerDetails             =  "test-Customer"

# ASG variables
# asg_sg_name                             = "demo-asg-sg"
# asg_sg_description                      = "demo-asg-sg"
# asg_sg_tags                             = { "Name" = "demo-asg-sg", "created-by" = "terraform" }
# asg_name                                = "demo-asg"
# asg_min_size                            = 0
# asg_max_size                            = 2
# asg_desired_capacity                    = 2
# asg_wait_for_capacity_timeout           = 0
# asg_health_check_type                   = "EC2"
# asg_launch_template_name                = "demo-lt"
# asg_launch_template_description         = "demo-lt"
# asg_update_default_version              = true
# asg_image_id                            = "ami-026b57f3c383c2eec"
# asg_instance_type                       = "t3.micro"
# asg_ebs_optimized                       = true
# asg_enable_monitoring                   = true
# asg_create_iam_instance_profile         = true
# asg_iam_role_name                       = "demo-asg-iam-role"
# asg_iam_role_path                       = "/ec2/"
# asg_iam_role_description                = "demo-asg-iam-role"
# asg_iam_role_tags                       = { "Name" = "demo-asg-iam-role", "created-by" = "terraform" }
# asg_block_device_mappings_volume_size_0 = 20
# asg_block_device_mappings_volume_size_1 = 30
# asg_instance_tags                       = { "Name" = "demo-asg-instance", "created-by" = "terraform" }
# asg_volume_tags                         = { "Name" = "demo-asg-volume", "created-by" = "terraform" }
# asg_tags                                = { "Name" = "demo-asg", "created-by" = "terraform" }

# # ALB variables
# alb_sg_name                    = "demo-alb-sg"
# alb_sg_ingress_cidr_blocks     = ["0.0.0.0/0"]
# alb_sg_description             = "demo-alb-sg"
# alb_sg_tags                    = { "Name" = "demo-alb-sg", "created-by" = "terraform" }
# alb_name                       = "demo-alb"
# alb_http_tcp_listeners_port    = 80
# alb_target_group_name          = "demo-alb-tg"
# alb_target_groups_backend_port = 80
# alb_tags                       = { "Name" = "demo-alb", "created-by" = "terraform" }