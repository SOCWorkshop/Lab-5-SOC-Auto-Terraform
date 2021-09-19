resource "aws_security_group" "allow_access_to_system" {
  name        = "allow_access_to_system"
  description = "Allow Participant to Access the System"

  ingress = [
    {
      description      = "Allowed Elasticsearch 2"
      from_port        = 9300
      to_port          = 9300
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description      = "Allowed Elasticsearch 1"
      from_port        = 9200
      to_port          = 9200
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description      = "Allowed Kibana"
      from_port        = 5601
      to_port          = 5601
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description      = "Allowed SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description      = "Allow Local Access"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["172.31.0.0/16"]
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]

  tags = {
    Name = "allow_access_to_system"
  }
}