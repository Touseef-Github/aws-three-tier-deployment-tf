resource "aws_security_group" "load_balancer_sg" {
  name        = "web-load-balancer-sg"
  description = "Security group for the Application Load Balancer for web access"
  vpc_id      = aws_vpc.VPC.id
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allowing HTTP access from the public
  }
  
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.EnvironmentName}-web-lb-sg"
  }
}

resource "aws_lb" "web" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_sg.id]
  subnets            = [aws_subnet.PublicSubnet1.id, aws_subnet.PublicSubnet2.id]
  enable_deletion_protection = false
  enable_http2        = true
  enable_cross_zone_load_balancing = true
  idle_timeout        = 60
 tags = {
    Name = "web-alb"
  }
}
 

resource "aws_lb_target_group" "web-tg" {
  name        = "web-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.VPC.id
}

resource "aws_lb_listener" "lb-listner" {
  load_balancer_arn = aws_lb.web.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:651130543852:certificate/7820e8e9-fdc2-4643-988c-168097fda7f0"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-tg.arn
  }
}

resource "aws_lb_listener" "redirect" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_target_group_attachment" "web-tg-attachment" {
  target_group_arn = aws_lb_target_group.web-tg.arn
  target_id        = aws_instance.EC2Instance.id  # Replace with your EC2 instance resource name
}

#########Private Load balancer ################

resource "aws_security_group" "load_balancer_sg2" {
  name        = "app-load-balancer-sg"
  description = "Security group for the Application Load Balancer for api access"
  vpc_id      = aws_vpc.VPC.id
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allowing HTTP access from the public
  }
  
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.EnvironmentName}-app-lb-sg"
  }
}

resource "aws_lb" "app-lb" {
  name               = "app-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_sg2.id]
  subnets            = [aws_subnet.PrivateSubnet1.id, aws_subnet.PrivateSubnet2.id]
  enable_deletion_protection = false
  enable_http2        = true
  enable_cross_zone_load_balancing = true
  idle_timeout        = 60
}

resource "aws_lb_target_group" "app-tg" {
  name        = "app-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.VPC.id
}

resource "aws_lb_listener" "lb-listner1" {
  load_balancer_arn = aws_lb.app-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-tg.arn
  }
}
