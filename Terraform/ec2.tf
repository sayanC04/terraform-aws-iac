#Data block

data "aws_ami" "os_image" {
  owners = ["099720109477"]
  most_recent = true
  filter {
    name = "state"
    values = ["available"]
  }
  filter {
     name   = "name"
    values = ["ubuntu/images/hvm-ssd/*amd64*"]
  }
}

#AWS key pair

resource "aws_key_pair" "my-key" {
  key_name   = "terra-key"
  public_key = file("id_ed25519.pub")
}

#AWS virtual private network

resource "aws_default_vpc" "default" {

}

#Security Group

resource "aws_security_group" "my_security_group" {
  name        = " z plus security"
  description = "this is a security group created by terraform"
  vpc_id      = aws_default_vpc.default.id #interpolation

  ingress {
    description = "allow acess to ssh port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow acess to port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "allow all outgoing traffic"
    to_port     = 0
    from_port   = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my z plus security"
  }

}

#Instance Configuration

resource "aws_instance" "my_instance" {
  #count = var.aws_instance_count # 1 meta argument count
  for_each = local.instances     # 2 meta argument count
  instance_type          = var._ec2_instance_type
  ami                    = data.aws_ami.os_image.id #interpolation
  vpc_security_group_ids = [aws_security_group.my_security_group.id] #interpolation
  key_name               = aws_key_pair.my-key.key_name              #interpolation
  root_block_device {

    volume_size = var.aws_root_volume_size
    volume_type = "gp3"
  }
  tags = {
    Name = each.value
  }
}


