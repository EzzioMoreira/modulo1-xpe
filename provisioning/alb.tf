resource "aws_lb" "this" {
  name               = "${var.tags.name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.this.id]
  subnets            = slice(data.aws_subnets.this.ids, 0, 2)

  enable_deletion_protection = false

  tags = var.tags
}

resource "aws_lb_target_group" "this" {
  name     = "${var.tags.name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = aws_lb_listener.this.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}
