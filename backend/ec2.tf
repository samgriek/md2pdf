resource "aws_security_group" "ec2_sg" {
  name        = "allow_https_ssh"
  description = "Allow inbound HTTPS, SSH traffic"

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

data "aws_ami" "ecs" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecs_instance_profile"
  role = "AmazonEC2ContainerServiceforEC2Role" # This role needs to be created in your AWS account
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ecs.id
  instance_type = "t3.small"
  key_name      = aws_key_pair.deployer.key_name
  iam_instance_profile = aws_iam_instance_profile.ecs_instance_profile.name
  vpc_security_group_ids = [aws_security_group.allow_http_https_ssh.id]
  subnet_id              = aws_subnet.subnet3.id
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${aws_ecs_cluster.cluster.name} >> /etc/ecs/ecs.config
              EOF

  tags = {
    Name = "API_SERVER" 
  }
}
