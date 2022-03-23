#==========================DB INSTANCE CODES======================
#-------------------------------------------------------------------
resource "aws_db_instance" "arcablanca_pt_rds" {
  identifier                    = "${var.rdsidentifier}"
  instance_class                = "${var.instance_class}"
  allocated_storage             = 5
  max_allocated_storage         = 100
  engine                        = "postgres"
  engine_version                = "13.1"
  username                      = "arcablanca-rusr"
  password                      = var.db_password
  db_subnet_group_name          = "${aws_db_subnet_group.arcablanca_pt_dbsubnets.id}"
  vpc_security_group_ids        = [aws_security_group.arcablanca_rds_sg.id]
  parameter_group_name          = "${aws_db_parameter_group.arcablanca-pt-rds.name}"
  publicly_accessible           = false
  skip_final_snapshot           = true
  auto_minor_version_upgrade    = false
  backup_window                 = "01:00-01:30" 
}

#==========================DB SUBNET GROUP======================
#-------------------------------------------------------------------
resource "aws_db_subnet_group" "arcablanca_pt_dbsubnets" {
  name       = "main"
  subnet_ids = ["${aws_subnet.private_subnet1.id}", "${aws_subnet.private_subnet2.id}", "${aws_subnet.private_subnet3.id}"]

  tags = {
    Name = "Arca-Blanca-PT-dbSubnet-Group"
  }
}

#==========================PARAMETER  RDS SG======================
#-------------------------------------------------------------------
resource "aws_security_group" "arcablanca_rds_sg" {
  name                          = "abpt_web_sg"
  description                   = "Allow traffic for arcablanca web apps"
  vpc_id                        = "${aws_vpc.arca-blanca-ptvpc.id}"

  ingress {
      from_port         = 5432
      to_port           = 5432
      protocol          = "tcp"
      security_groups   = ["${aws_security_group.arcablanca-alb-sg.id}"]
  }  
  ingress {
      from_port         = 5433
      to_port           = 5433
      protocol          = "tcp"
      security_groups = ["${aws_security_group.arcablanca-alb-sg.id}"]
  }
  egress {
      from_port         = 0
      to_port           = 0
      protocol          = "tcp"
      ipv6_cidr_blocks = ["0.0.0.0/0"]
  }
}


#==========================PARAMETER  GROUP======================
#-------------------------------------------------------------------
resource "aws_db_parameter_group" "arcablanca-pt-rds" {
  name   = "arcablanca-pt-rds"
  family = "postgres13"

  parameter {
    name  = "arcablanca_pt_log_connections"
    value = "1"
  }
}


#==========================DB CREDENTIALS======================
#-------------------------------------------------------------------
variable "db_password" {
  description = "RDS root user password"
  type        = string
  sensitive   = true
  default = "testdb"
}


#==========================DB OUTPUTS======================
#-------------------------------------------------------------------
output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.arcablanca_pt_rds.address
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.arcablanca_pt_rds.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.arcablanca_pt_rds.username
  sensitive   = true
}

