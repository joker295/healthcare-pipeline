output"vpc_id"{

   value= aws_vpc.project-VPC.id
}


output "subnet_id" {
  
  value = [for subnet in  aws_subnet.public-subnets : subnet.id]
}