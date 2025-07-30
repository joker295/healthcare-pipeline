resource "aws_instance" "master-machine" {
  count             =  1 
  ami               = "ami-0f918f7e67a3323f0"
  key_name         =  "Monitoring"
  instance_type     = "t3.medium"
  subnet_id         = var.subnet_id[0]   
  vpc_security_group_ids = [aws_security_group.master-sg.id]
  associate_public_ip_address = true


  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install openjdk-17-jdk -y
    sudo apt install docker.io -y
    sudo systemctl enable docker
    sudo apt update -y
    sudo apt install maven -y
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt update -y
    sudo apt install jenkins -y
    service jenkins start
    sudo apt update -y
    sudo usermod -aG jenkins Docker
    sudo apt-get install -y software-properties-common
    sudo apt-add-repository ppa:ansible/ansible
    sudo apt-get update
    sudo apt-get install -y ansible
  EOF

root_block_device {
  
  volume_size           = 20 
  volume_type           = "gp3"
  delete_on_termination = "true"
}

  tags = {
    Name = "master-machine"
  }

}


# # EBS volume 

# resource "aws_ebs_volume" "master-volume"{

# availability_zone = aws_instance.master-machine[0].availability_zone
# size              = 30 
  
# }

# # EBS volume attachment 

# resource "aws_volume_attachment" "attach_master"{
  
#   device_name = "/dev/sdf"
#   volume_id = aws_ebs_volume.master-volume.id
#   instance_id = aws_instance.master-machine[0].id

# }



# Security Group

resource "aws_security_group" "master-sg" {

  name   = "master-sg"
  vpc_id = var.vpc_id
   
    ingress {
    description = "Allow all SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP" 
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {  
    description = "Allow all HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP" 
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = "Allow all HTTPS traffic"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow all HTTPS traffic"
    from_port   = "443"
    to_port     = "443"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all Jenkins traffic"
    from_port   = "8080"
    to_port     = "8080"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}

# Worker-Nodes

resource "aws_instance" "worker-machine" {
  
  count                  =  2
  ami                    = "ami-0f918f7e67a3323f0"
  subnet_id              =  var.subnet_id[1]
  vpc_security_group_ids = [aws_security_group.worker-machine-sg.id]
  instance_type          = "t3.medium"
  associate_public_ip_address = true
  key_name               = "Monitoring"

  tags = {
    Name = "worker-${count.index+1}"
  }

}

resource "aws_security_group" "worker-machine-sg" {
  vpc_id = var.vpc_id
  name= "worker-machine-sg"

  ingress {
    description = "Allow all SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
    }

      ingress {
    description = "Allow all HTTPS traffic"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow all HTTPS traffic"
    from_port   = "8091"
    to_port     = "8091"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow all k8s traffic"
    from_port   = "6443"
    to_port     = "6443"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   =   0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  }
