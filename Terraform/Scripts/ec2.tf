resource "aws_instance" "web" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.Pub.id
  security_groups = [aws_security_group.PUB.id]
  
  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_security_group" "PUB" {
  name   = "sg"
  vpc_id = aws_vpc.VPC.id

ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #security_groups = [aws_security_group.public_ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}