resource "aws_ecs_cluster" "arca-blanca-fargate-cluster" {
  name = "${var.arca-blanca-clustername}"
}

resource "aws_alb" "arca-blanca-ecs-cluster_alb" {
  name                      = "${var.arca-blanca-clustername}-ALB"
  internal                  = false
  security_groups           = ["${aws_security_group.arcablanca-alb-sg.id}"] 
  subnets                   = ["${aws_subnet.pub_subnet1.id}", "${aws_subnet.pub_subnet2.id}", "${aws_subnet.pub_subnet3.id}"] //["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] 

  tags = {
      Name                  = "${var.arca-blanca-clustername}-ALB"
  }
}

#ALB listener to permit us use our ALB. 
resource "aws_alb_listener" "abpt_ecs_https_listener" {
  load_balancer_arn         = "${aws_alb.arca-blanca-ecs-cluster_alb.arn}"
  port                      = 443
  protocol                  = "HTTPS"
  ssl_policy               = "ELBSecurityPolicy-TLS-1-2-2017-01"  
  certificate_arn           = "${aws_acm_certificate.arca-blanca-domaincert.arn}"

  default_action {
    type               = "forward"
    target_group_arn   = "${aws_alb_target_group.abpt_ecs_default_tg.arn}"
  }

  depends_on = [aws_alb_target_group.abpt_ecs_default_tg]
}

#Arca Blanca ALB ECS default target group. Note, this may not be used in our application deployment
resource "aws_alb_target_group" "abpt_ecs_default_tg" {
  name                      = "${var.arca-blanca-fargate-cluster}-TG"
  port                      = 80
  protocol                  = "HTTP"
  vpc_id                    = "${aws_vpc.arca-blanca-ptvpc.id}"

  tags = {
    "name"                  = "${var.arca-blanca-fargate-cluster}-TG"
  }
}

resource "aws_route53_record" "abpt_ecs_loadbalancer_record" {
  name                      = "*.${var.ecs_arcablanca_domain}"
  type                      = "A"
  zone_id                   = "${data.aws_route53_zone.arca-blanca-ecsdomain.zone_id}"

  alias {
    evaluate_target_health  = false
    name                    = "${aws_alb.arca-blanca-ecs-cluster_alb.dns_name}"
    zone_id                 = "${aws_alb.arca-blanca-ecs-cluster_alb.zone_id}" 
   }
}

resource "aws_iam_role" "abpt_ecs_cluster_role" {
  name                      = "${var.arca-blanca-fargate-cluster}-IAM-Role"
  assume_role_policy  = <<EOF
{
    "Version":  "2012-10-17",
    "Statement": [
    {
        "Effect": "Allow",
        "Principal": {
            "Service": ["ecs.amazonaws.com", "ec2.amazonaws.com", "application-autoscaling.amazonaws.com"]
        },
        "Action": "sts:AssumeRole"
    }
    ]
}
  EOF 
}

resource "aws_iam_role_policy" "abpt_ecs_cluster_policy" {
  name                          = "${var.arca-blanca-fargate-cluster}-IAM-Policy"
  role                          = "${aws_iam_role.abpt_ecs_cluster_role.id}"
  policy                        = <<EOF
{
    "Version":  "2012-10-17",
    "Statement": [
    {
        "Effect": "Allow",
        "Actions": [
            "ecs:*",
            "ec2:*",
            "elasticloadbalancing:*",
            "ecr:*",
            "dynamodb:*",
            "cloudwatch:*",
            "s3:*",
            "rds:*",
            "sqs:*",
            "sns:*",
            "logs:*",
            "ssm:*"
        ],
        "Resource": "*"
    }
    ]
}
  EOF
}