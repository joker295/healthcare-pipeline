module "VPC" {

source = "./module/VPC"

}

module "EC2" {

  source = "./module/EC2"
  vpc_id = module.VPC.vpc_id
  subnet_id = module.VPC.subnet_id
  
}
