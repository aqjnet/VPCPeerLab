## INSTANCES #################

resource "aws_instance" "PC1" {
  ami           = var.ami
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    aws_security_group.sg_ssh.id,
    aws_security_group.sg_https.id,
    aws_security_group.sg_http.id
  ]
  subnet_id = aws_subnet.my_subnet.id
  key_name  = "aws_key"


  tags = {
    area           = "iDMZ"
    classification = "internal"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "aws_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDOZLL2yEPZmd5Et7uWAyCgySXI2ZduZYBbsd9Xqfn1xSTGJDjm8u9oYbfz3JObcwSPiNg858MTQbuJzRbnMMUgnMb4P6qTQbvljOjAO3Y737uBuWPKB93GTvsk0wSRYcEw6ljW/voH+7GxDf5y6r6K0D2y+a2z5FSMjODjcKhnqzmgufweQFtbUX1XLlJp8007q9+utQx1OH0YiPPyMCVNpHxR093haUPKIFlHyLx1WOTKx3Mu5kXT9NgPzjtzwp18Wm5pCK7CzepYnA5I09Iw1B8UWN4klEOhqPoi7kUMeP7OBOf1l1vMYgtw2oHe52vu5/s9XIJ/Eo3byxbhscRU0XGaI1A452E9aRP0HEfTkWZgks2zXRec9B2Pk28xdxEGKiBIkiSwbh/Uil8zVgUrQfdOT/Hodhk8UkAXFZH/4qfavQR7W3grbCdHtCItj9NRRrIeLwqEzi5K/kL6jTvtcyVII2QOZha0FqIFco5JcvChsT7BJDosRag7LAoebUM= admin@PC1"
}

## NETWORKING ##

##THE VPC##

resource "aws_vpc" "my_vpc1" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tf-example1"
  }
}

#~SECURITY GROUPS FOR YOUR VPC~#
resource "aws_security_group" "sg_ssh" {
  vpc_id = aws_vpc.my_vpc1.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
}

resource "aws_security_group" "sg_https" {

  vpc_id = aws_vpc.my_vpc1.id
  ingress {
    cidr_blocks = ["192.168.0.0/16"]
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
}

resource "aws_security_group" "sg_http" {
  vpc_id = aws_vpc.my_vpc1.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
}

#SUBNET - REMEMBER IT NEEDS A ROUTE OUT OF THE SUBNET!!!################################

resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc1.id
  cidr_block              = "172.16.10.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_internet_gateway" "prod-igw" {
    vpc_id = aws_vpc.my_vpc1.id
    tags = {
        Name = "prod-igw"
    }
}

resource "aws_route_table" "prod-public-crt" {
    vpc_id = aws_vpc.my_vpc1.id
    
    route {
        cidr_block = "0.0.0.0/0" 
        gateway_id = aws_internet_gateway.prod-igw.id
    }
    
    tags = {
        Name = "prod-public-crt"
    }
}
resource "aws_route_table_association" "prod-crta-public-subnet-1"{
    subnet_id = aws_subnet.my_subnet.id
    route_table_id = aws_route_table.prod-public-crt.id
}