# ALB를 위한 보안 그룹 생성
resource "aws_security_group" "alb_sg" {
  vpc_id = module.vpc.vpc_id
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # 외부에서 접근 가능
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "${var.cluster_name}-alb-sg"
  })
}

# ALB 설정
resource "aws_lb" "my_app_alb" {
  name               = "${var.cluster_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets  # 퍼블릭 서브넷 사용

  tags = merge(local.tags, {
    Name = "${var.cluster_name}-alb"
  })
}

# ALB Target Group 설정
resource "aws_lb_target_group" "my_app_target_group" {
  name     = "${var.cluster_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/health"  # 헬스 체크 경로
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# ALB Listener 설정
resource "aws_lb_listener" "my_app_listener" {
  load_balancer_arn = aws_lb.my_app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_app_target_group.arn
  }
}
