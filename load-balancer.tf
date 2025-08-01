# Application Load Balancer
resource "aws_lb" "main" {
  name               = "${var.project_name}-${var.environment}-alb"
  internal           = false  # Internet-facing
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets           = aws_subnet.public[*].id

  enable_deletion_protection = false  # Set to true in production

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-alb"
  })
}

# Target Group for Web Servers
resource "aws_lb_target_group" "web" {
  name     = "${var.project_name}-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  # Health check configuration
  health_check {
    enabled             = true
    healthy_threshold   = 2      # Number of consecutive successful checks
    interval            = 30     # Seconds between checks
    matcher             = "200"  # Expected HTTP response code
    path                = "/"    # Health check path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5      # Seconds to wait for response
    unhealthy_threshold = 2      # Number of consecutive failed checks
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-web-tg"
  })
}

# Load Balancer Listener
resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-web-listener"
  })
}