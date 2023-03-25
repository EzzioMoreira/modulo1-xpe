resource "aws_launch_configuration" "this" {
  name_prefix   = "${var.tags.name}-lc"
  image_id      = data.aws_ami.this.id
  instance_type = var.instance_type
}

resource "aws_autoscaling_group" "this" {
  name                 = "${var.tags.name}-asg"
  launch_configuration = aws_launch_configuration.this.id
  vpc_zone_identifier  = slice(data.aws_subnets.this.ids, 0, 2)
  min_size             = 1
  max_size             = 5
  desired_capacity     = 1
  target_group_arns    = [aws_lb_target_group.this.arn]
}

resource "aws_autoscaling_policy" "this" {
  autoscaling_group_name = aws_autoscaling_group.this.name
  name                   = "${var.tags.name}-asg-policy"
  policy_type            = "PredictiveScaling"
  predictive_scaling_configuration {
    metric_specification {
      target_value = 30
      predefined_load_metric_specification {
        predefined_metric_type = "ASGTotalCPUUtilization"
        resource_label         = "testLabel"
      }
      customized_scaling_metric_specification {
        metric_data_queries {
          id = "scaling"
          metric_stat {
            metric {
              metric_name = "CPUUtilization"
              namespace   = "AWS/EC2"
              dimensions {
                name  = "AutoScalingGroupName"
                value = "my-test-asg"
              }
            }
            stat = "Average"
          }
        }
      }
    }
  }
}
