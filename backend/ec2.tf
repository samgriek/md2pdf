resource "aws_security_group" "ec2_sg" {
  name        = "allow_http_https_ssh"
  description = "Allow inbound HTTP, HTTPS, SSH traffic"

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/private_id_ed25519.pub")
}


resource "aws_instance" "web" {
  ami           = "ami-05f6435f6fe49a9e1" 
  instance_type = "t2.micro"
  key_name = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.ec2_sg.name]
  
  tags = {
    Name = "API_SERVER"
  }
}
