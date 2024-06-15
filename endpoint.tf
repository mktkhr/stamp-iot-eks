resource "aws_ec2_instance_connect_endpoint" "eice" {
  subnet_id          = aws_subnet.kubectl_subnet.id
  security_group_ids = [aws_security_group.kubectl_sg.id]
}

data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_network_interface" "kubectl_ni" {
  subnet_id       = aws_subnet.kubectl_subnet.id
  security_groups = [aws_security_group.kubectl_sg.id]
}

resource "aws_iam_instance_profile" "kubectl_iam_instance_profile" {
  name = var.instance_iam_instance_profile_name
  role = aws_iam_role.kubectl_role.name
}

resource "aws_instance" "kubectl_instance" {
  ami                  = data.aws_ssm_parameter.ami.value
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.kubectl_iam_instance_profile.name
  network_interface {
    network_interface_id = aws_network_interface.kubectl_ni.id
    device_index         = 0
  }
}

resource "aws_iam_policy" "kubectl_policy" {
  name        = "test_kubectl_policy"
  description = "test kubectl policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:GetCallerIdentity",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "kubectl_role" {
  name = "test_kubectl_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "kubectl_iam_role_policy_attachment" {
  policy_arn = aws_iam_policy.kubectl_policy.arn
  role       = aws_iam_role.kubectl_role.name
}

data "http" "client_global_ip" {
  url = "https://ifconfig.co/ip"
}

locals {
  allowed_cidr = replace("${data.http.client_global_ip.response_body}/32", "\n", "")
}

resource "aws_subnet" "kubectl_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  cidr_block              = var.instance_subnet_cidr_block
}

resource "aws_route_table_association" "kubectl_rta" {
  subnet_id      = aws_subnet.kubectl_subnet.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "kubectl_sg" {
  name = "kubectl-sg"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.allowed_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}