#Modify below Variables with your vpc-id, public subnet-group id and ALB dns endpoint values.

variable "vpc_id" {
  default = "vpc-000****000"
}

variable "public_subnet_ap_south_1a" {
  default = "subnet-000****0001a"
}

variable "public_subnet_ap_south_1b" {
  default = "subnet-000****0001b"
}

variable "alb_dns_name" {
  default = "internal-xxxx****xxxx.ap-south-1.elb.amazonaws.com"
}
