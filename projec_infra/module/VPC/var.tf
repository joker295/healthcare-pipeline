variable "vpc_cidr" {

    default = "10.0.0.0/16"
  
}

variable "subnet_cidr"{

    type =  list(object({
      name       = string 
      cidr_block = string
      availability_zone= string

     }))
    default = [
        {
            name = "public_subnet_1"
            cidr_block = "10.0.1.0/24"
            availability_zone = "ap-south-1a"
        },
        {
            name = "public_subnet_2"
            cidr_block = "10.0.2.0/24"
            availability_zone = "ap-south-1b"
        }
    ] 


}