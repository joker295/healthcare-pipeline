resource"aws_vpc""project-VPC"{

    cidr_block = var.vpc_cidr
    
}

# Subnets

resource "aws_subnet""public-subnets"{
    for_each = {for subnet in var.subnet_cidr: subnet.name=> subnet}

vpc_id     = aws_vpc.project-VPC.id
cidr_block = each.value.cidr_block
availability_zone = each.value.availability_zone
  
}

# Internet Gateway

resource "aws_internet_gateway""Dev-IGW"{

    vpc_id = aws_vpc.project-VPC.id
}


# Route Tables 

resource "aws_route_table""route_table"{
vpc_id = aws_vpc.project-VPC.id
route {

    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Dev-IGW.id

    }
}

resource "aws_route_table_association""association"{
  for_each= aws_subnet.public-subnets

  subnet_id = each.value.id
  route_table_id = aws_route_table.route_table.id



}