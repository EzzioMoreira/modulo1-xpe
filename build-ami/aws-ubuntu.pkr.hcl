
variable "ami_name" {
  type        = string
  default     = "modulo-1-xpe"
  description = "Ami name"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The name AWS availability zone"
}

variable "instance_typ" {
  type        = string
  default     = "t3a.small"
  description = "Type instace ec2"
}

data "amazon-ami" "this" {
  filters = {
    name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["099720109477"]
  region      = "${var.region}"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "this" {
  ami_description = "ami from {{ .SourceAMI }}"
  ami_name        = "${var.ami_name} ${local.timestamp}"
  instance_type   = "${var.instance_typ}"
  region          = "${var.region}"
  source_ami      = "${data.amazon-ami.this.id}"
  ssh_username    = "ubuntu"
  tags = {
    base_AMI_Name = "{{ .SourceAMIName }}"
    os_version    = "Ubuntu"
    release       = "20.04"
    name          = "${var.ami_name}"
    team          = "iac",
    application   = "rapadura",
    sistema       = "metal.corp"
    environment   = "production",
    mgmt          = "packer",
    owner         = "metal.corp"
  }
}

build {
  sources = ["source.amazon-ebs.this"]

  provisioner "ansible" {
    ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False"]
    extra_arguments  = ["--extra-vars", "ansible_python_interpreter=/usr/bin/python3"]
    playbook_file    = "./playbook.yml"
    user             = "ubuntu"
  }
}
