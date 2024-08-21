####EC2 INSTANCE####

resource "aws_instance" "lesson_05" {
  ami           = "ami-097a2df4ac947655f"
  instance_type = "t2.micro"
  key_name      = "aws_key"
  subnet_id     = aws_subnet.my_subnet.id
  vpc_security_group_ids = [
    aws_security_group.sg_ssh.id,
    aws_security_group.sg_https.id,
    aws_security_group.sg_http.id
  ]

  tags = {
    Name                    = "Lesson_05"
    Vanquisher_of_Gothmog   = "Ecthelion"
    Vanquisher_of_Ecthelion = "Gothmog"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "aws_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7Uqs70iiGd4Uk2kvrLszQY3xDZnZ85ZkrytI7gDHkEOhYjvuvLMw3garg784Tn761m0tVVP8WmDkW46ds/FykuyBjsNswLJk/RNzOcPY6LIbFY01WZ7a9uXsOoGVY/x4cpURvGvNOCo5WcvapxqhtdFij7LXdgmD6hssePa+NpNbLBCCSuqC7MWlxybtJdYq9QBb7pnVRr5FGv2cCUEjaPA2JmSg2qYgjhBCYHe85AK5/x7f02d1FRjVtNJIK07c7X0H7FwND6uwApC5giJcV2QWnnNgbNu3R9IKlWW3nYai8nDZqArGqph8Jx8F3tgOX4TjE6dEMw619I6qShAxDbD3ThQBIUVbncHix5HFIxkDc8Do+7VvLAKAl963/GbQoJHs5O09B1PJtHwVE5bEcBvX4NV/1e873/gadw/HOnllNz4x9qmJqijk8B0R35kNAmnnJ1+yEvoP65uLLVs676BDu2WAStPlBsKLiP272ua9xeraTEWpI8LWgOLq0gb0= admin@PC1"
}

####VPC####

resource "aws_vpc" "my_vpc1" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tf-example1"
  }
}

####NETWORKING####

resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc1.id
  cidr_block              = "172.16.10.0/24"
  availability_zone       = "us-east-2a"
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
resource "aws_route_table_association" "prod-crta-public-subnet-1" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.prod-public-crt.id
}


####SECURITY GROUPS####

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
    cidr_blocks = ["172.16.0.0/16"]
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