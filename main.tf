## INSTANCES #################

resource "aws_instance" "PC1" {
  ami           = ""
  instance_type = "t2.micro"

  tags = {
    area           = "iDMZ"
    classification = "internal"
  }
}

resource "aws_instance" "PC2" {
  ami           = ""
  instance_type = "t2.micro"

  tags = {
    area           = "iDMZ1"
    classification = "internal"
  }
}

## NETWORKING ##

resource "aws_vpc" "my_vpc1" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tf-example1"
  }
}

resource "aws_vpc" "my_vpc2" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tf-example2"
  }
}

resource "aws_subnet" "my_subnet1" {
  vpc_id     = aws_vpc.my_vpc1.id
  cidr_block = "172.16.10.0/24"


  tags = {
    Name = "tf-example"
  }
}

resource "aws_subnet" "my_subnet2" {
  vpc_id     = aws_vpc.my_vpc2.id
  cidr_block = "172.16.11.0/24"


  tags = {
    Name = "tf-example"
  }
}


resource "aws_security_group" "allow_ssh1" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.my_vpc1.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_security_group" "allow_ssh2" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.my_vpc2.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_security_group" "allow_tls1" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.my_vpc1.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_security_group" "allow_tls2" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.my_vpc2.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_security_group" "allow_vpc1" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.my_vpc2.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_security_group" "allow_vpc2" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.my_vpc1.id

  tags = {
    Name = "allow_tls"
  }
}

### VPC Peering ###

resource "aws_vpc_peering_connection" "vpcPeer" {
  peer_owner_id = var.peer_owner_id
  peer_vpc_id   = aws_vpc.my_vpc2.id
  vpc_id        = aws_vpc.my_vpc1.id
  auto_accept   = true

  tags = {
    Name = "VPC Peering between vpc1 and vpc2"
  }
}