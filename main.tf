#Provider, s3 bucket details, Project Name, env etc... need to configure as per your requirements.
# In here I provide sample names and configurations dor the same.

provider "aws" {
  profile = "develop"
  region  = "ap-south-1"
  version = "~> 3.1.0"
}
terraform {
  backend "s3" {
    bucket  = "devops-tfstate-develop"
    key     = "devops/nlb-for-alb/terraform.tfstate"
    region  = "ap-south-1"
    profile = "develop"
  }
}

variable "ProjectName" {
  default = "nlb-for-alb"
}
variable "CreatedBy" {
  default = "Devakrishnan Nampoothiri"
}
variable "env" {
  default = "develop"
}
