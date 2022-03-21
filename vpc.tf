# Create the VPC
resource "aws_vpc" "arca-blanca-ptvpc" {
   cidr_block                   = "${var.vpc_cidr}"
   enable_dns_hostnames         = "${var.enable_dns_hostnames}"  

   tags = {
       name = "Arca-Blanca-PricingTool VPC"
   }
}

#create public subnet 1
resource "aws_subnet" "pub_subnet1" {
  cidr_block                    = "${var.arcablanca_pub_subnet_1_cidr}"
  vpc_id                        = "${aws_vpc.arca-blanca-ptvpc.id}"
  availability_zone             = "us-east-1a"

  tags = {
      name = "Arca-Blanca-Public-Subnet-1"
  }
}

resource "aws_subnet" "pub_subnet2" {
  cidr_block                    = "${var.arcablanca_pub_subnet_2_cidr}"
  vpc_id                        = "${aws_vpc.arca-blanca-ptvpc.id}"
  availability_zone             = "us-east-1b"

  tags = {
      name = "Arca-Blanca-Public-Subnet-2"
  }
}

resource "aws_subnet" "pub_subnet3" {
  cidr_block                    = "${var.arcablanca_pub_subnet_3_cidr}"
  vpc_id                        = "${aws_vpc.arca-blanca-ptvpc.id}"
  availability_zone             = "us-east-1c"

  tags = {
      name = "Arca-Blanca-Public-Subnet-3"
  }
}

resource "aws_subnet" "private_subnet1" {
  cidr_block                    = "${var.arcablanca_private_subnet_1_cidr}"
  vpc_id                        = "${aws_vpc.arca-blanca-ptvpc.id}"
  availability_zone             = "us-east-1a"

  tags = {
      name = "Arca-Blanca-Private-Subnet-1"
  }
}

resource "aws_subnet" "private_subnet2" {
  cidr_block                    = "${var.arcablanca_private_subnet_2_cidr}"
  vpc_id                        = "${aws_vpc.arca-blanca-ptvpc.id}"
  availability_zone             = "us-east-1b"

  tags = {
      name = "Arca-Blanca-Private-Subnet-2"
  }
}

resource "aws_subnet" "private_subnet3" {
  cidr_block                    = "${var.arcablanca_private_subnet_3_cidr}"
  vpc_id                        = "${aws_vpc.arca-blanca-ptvpc.id}"
  availability_zone             = "us-east-1b"

  tags = {
      name = "Arca-Blanca-Private-Subnet-3"
  }
}

resource "aws_route_table" "arcablanca_PubRT" {
  vpc_id                    = "${aws_vpc.arca-blanca-ptvpc.id}" 

  tags = {
      name = "Arca-Blanca_Public_Route_Table"
  }
}

resource "aws_route_table" "arcablanca_PrivateRT" {
  vpc_id                    = "${aws_vpc.arca-blanca-ptvpc.id}" 

  tags = {
      name = "Arca-Blanca_Private_Route_Table"
  }
}


#create public subnet association binding them to the public route table
resource "aws_route_table_association" "public_subnet1_association" {
  route_table_id            = "${aws.route_table.arcablanca_PubRT.id}"
  subnet_id                 = "${aws_subnet.pub_subnet1.id}" 
}

resource "aws_route_table_association" "public_subnet2_association" {
  route_table_id            = "${aws.route_table.arcablanca_PubRT.id}"
  subnet_id                 = "${aws_subnet.pub_subnet2.id}" 
}

resource "aws_route_table_association" "public_subnet3_association" {
  route_table_id            = "${aws.route_table.arcablanca_PubRT.id}"
  subnet_id                 = "${aws_subnet.pub_subnet3.id}" 
}


#create Private subnet association binding them to the private route table
resource "aws_route_table_association" "private_subnet1_association" {
  route_table_id            = "${aws.route_table.arcablanca_PrivateRT.id}"
  subnet_id                 = "${aws_subnet.private_subnet1.id}" 
}

resource "aws_route_table_association" "private_subnet2_association" {
  route_table_id            = "${aws.route_table.arcablanca_PrivateRT.id}"
  subnet_id                 = "${aws_subnet.private_subnet2.id}" 
}

resource "aws_route_table_association" "private_subnet3_association" {
  route_table_id            = "${aws.route_table.arcablanca_PrivateRT.id}"
  subnet_id                 = "${aws_subnet.private_subnet3.id}" 
}

#enable aws_eip and associate it with a chosen ip address
resource "aws_eip" "arcablanca-eip" {
  vpc                       = true
  associate_with_private_ip = "10.0.0.5"

  tags = {
      name  = "Arca-Blanca-EIP-4-NAT-GW"
  }
}

# Create a NAT GW and make sure there is an eip before creating the nat
resource "aws_nat_gateway" "nat_gw" {
    allocated_id            = "${aws_eip.arcablanca-eip.id}"
    subnet_id               = "${aws_subnet.pub_subnet1.id}"

    tags = {
        name = "Arcablanca-Production-NAT-Gateway"
    }
    #Making sure there is an eip
    depends_on = ["aws_eip.arcablanca-eip"]
}

#Create a route to external world to the private route table
resource "aws_route"  "nat-gw-route" {
    route_table_id          = "${aws_route_table.arcablanca_PrivateRT.id}"
    nat_gateway_id          = "${aws_nat_gateway.nat_gw.id}"
    destination_cidr_block  = "0.0.0.0/0" 
}

#Create an internet gateway and assign it to the main vpc
resource "aws_internet_gateway" "arcablanca_prod_igw" {
  vpc_id                    = "${aws_vpc.arca-blanca-ptvpc.id}" 

  tags = {
      name = "Arca-Blanca-Production-IGW"
  }
}

resource "aws_route" "arcablanca-igw-route" {
    route_table_id          = "${aws_route_table.arcablanca_PubRT.id}" 
    gateway_id              = "${aws_internet_gateway.arcablanca_prod_igw.id}" 
    destination_cidr_block  = "0.0.0.0/0" 
}