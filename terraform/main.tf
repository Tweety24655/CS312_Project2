provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "minecraft_key" {
  key_name   = "minecraft-key"
  public_key = file("${path.module}/minecraft-key.pub")
}

resource "aws_security_group" "minecraft_sg" {
  name        = "minecraft-sg"
  description = "Allow Minecraft and SSH access"

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "minecraft_server" {
  ami                    = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.minecraft_key.key_name
  vpc_security_group_ids = [aws_security_group.minecraft_sg.id]

  provisioner "file" {
    source      = "setup-minecraft.sh"
    destination = "/home/ec2-user/setup-minecraft.sh"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${path.module}/minecraft-key.pem")
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/setup-minecraft.sh",
      "bash ~/setup-minecraft.sh"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${path.module}/minecraft-key.pem")
      host        = self.public_ip
    }
  }

  tags = {
    Name = "MinecraftServer"
  }
}
