resource "aws_security_group" "arcablanca-alb-sg" {
  name                  = "${var.arca-blanca-clustername}-ALB-SG"
  description           = "Security group for ALB to traffic for ECS Cluster"
  vpc_id                = "${aws_vpc.arca-blanca-ptvpc.id}"
  

  ingress {
      from_port         = 443
      protocol          = "TCP"
      to_port           = 443 
      cidr_blocks       = ["${var.arcblanca_internet_cidr}"]
  } 

  egress {
      from_port         = 0
      protocol          = "-1"
      to_port           = 0 
      cidr_blocks       = ["${var.arcblanca_internet_cidr}"]
  }
}