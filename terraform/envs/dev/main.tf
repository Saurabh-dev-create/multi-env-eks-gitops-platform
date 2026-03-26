terraform {
  backend "s3" {
    bucket         = "devops-terraform-state-saurabh" 
    key            = "dev/vpc/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-locks"
  }
}
module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr = var.vpc_cidr

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  availability_zones = var.availability_zones

  environment = "dev"
}
module "eks" {
  source = "../../modules/eks"

  cluster_name = "dev-eks"

  subnet_ids = module.vpc.private_subnets
  vpc_id     = module.vpc.vpc_id
}