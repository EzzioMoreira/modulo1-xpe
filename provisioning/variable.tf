variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "instance_type" {
  type        = string
  default     = "t3a.micro"
  description = "The list of instance type."
}

variable "tags" {
  type = object({
    name        = string
    team        = string
    application = string
    sistema     = string
    enviroment  = string
    mgnt        = string
    owner       = string
  })
  default = {
    application = "rapadura"
    enviroment  = "production"
    mgnt        = "terraform"
    name        = "app-web-rapadura"
    owner       = "metal.corp"
    sistema     = "rapadura"
    team        = "devops"
  }
}

variable "vpc_id" {
  type        = string
  description = "VPC ID value"
}

variable "var.aws_account_id" {
  type        = number
  description = "AWS account id"
}
