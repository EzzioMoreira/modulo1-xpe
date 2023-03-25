data "aws_ami" "this" {
  most_recent = true
  owners      = var.aws_account_id

  filter {
    name   = "tag:name"
    values = ["modulo-1-xpe"]
  }
}

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}
