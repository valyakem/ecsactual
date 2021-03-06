data "template_file" "abpt_ecs_task_definition_template" {

    template = file("${path.module}/task_definition.json")

    // these are application variables to be used with our app.
     vars = {
        task_definition_name = "${var.abpt_ecs_service_name}"
        ecs_service_name     = "${var.abpt_ecs_service_name}"
        docker_image_url     = "${var.docker_image_url}"
        memory               = "${var.abpt_docker_memory}"
        docker_container_port= "${var.abpt_docker_container_port}"
        arcablanca_pt_profile= "${var.arcablanca_pt_profile}"
        region               = "${var.region}"
  }

   
}

#create a task definition resources for arca blanca and render our json template
resource "aws_ecs_task_definition" "arcablancaptapp-task-definition" {
  container_definitions     = data.template_file.abpt_ecs_task_definition_template.rendered
  family                    = "${var.abpt_ecs_service_name}"
  cpu                       = 512
  memory                    = "${var.abpt_docker_memory}"
  requires_compatibilities  = ["FARGATE"]
  network_mode              = "awsvpc"
  execution_role_arn        = "${aws_iam_role.abpt_fargate_iam_role.arn}"
  task_role_arn         = "${aws_iam_role.abpt_fargate_iam_role.arn}"
}

//create an iam role for arca blanca to be used with our ecs service
resource "aws_iam_role" "abpt_fargate_iam_role" {
  name                      = "${var.abpt_ecs_service_name}-IAM-Role"

assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}
//create teh abpt fargate policy to be assigned to the role
resource "aws_iam_role_policy" "abpt_fargate_iam_role_policy" {
  name                          = "${var.abpt_ecs_service_name}-IAM-Role-Policy" 
  role                          = "${aws_iam_role.abpt_fargate_iam_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecs:*",
        "ecr:*",
        "logs:*",
        "cloudwatch:*",
        "elasticloadbalancing:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_security_group" "abpt_app_security_group" {
  name                              = "${var.abpt_ecs_service_name}-SG"
  description                       = "Security Group for our Arca-BLANCA application to communitcate in and out"
  vpc_id                            = "${aws_vpc.arca-blanca-ptvpc.id}"

  ingress {
      from_port     = 5000
      protocol      = "TCP"
      to_port    = 5000 
      cidr_blocks   = ["${var.vpc_cidr}"] 
  }

  egress {
      from_port     = 0
      protocol      = "-1"
      to_port    = 0 
      cidr_blocks   = ["0.0.0.0/0"]  
  }

  tags = {
    "name"          = "${var.abpt_ecs_service_name}-SG"
  }
}

resource "aws_alb_target_group" "abpt_ecs_app_target_group" {
  name                                  = "${var.abpt_ecs_service_name}-TG"
  port                                  = "${var.abpt_docker_container_port}"
  protocol                              = "HTTP"
  vpc_id                                = "${aws_vpc.arca-blanca-ptvpc.id}"
  target_type                           = "ip" 
  
// provide health check data if any  
  health_check {
    path                = "/"
    port                = 5000
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-499"
  }

  tags = {
    "name" = "${var.abpt_ecs_service_name}-TG"
  }
}


# resource "aws_lb_target_group_attachment" "test" {
#   target_group_arn = aws_alb_target_group.abpt_ecs_app_target_group.arn
#   target_id        = aws_instance.test.id
#   port             = 80
# }

# ECS services for our fargate implementation n
resource "aws_ecs_service" "abpt_ecs_service" {
    name                                    = "${var.abpt_ecs_service_name}" 
    task_definition                         = "${var.abpt_ecs_service_name}"
    desired_count                           = "${var.desired_count_number}" 
    cluster                                 = "${var.arca-blanca-clustername}"
    launch_type                             = "FARGATE" 

    depends_on      = [aws_eip.arcablanca-eip]

    network_configuration {
      subnets           = ["${aws_subnet.pub_subnet1.id}", "${aws_subnet.pub_subnet2.id}", "${aws_subnet.pub_subnet3.id}"]
      security_groups   = ["${aws_security_group.abpt_app_security_group.id}"]
      assign_public_ip  = true 
    }

    load_balancer {
      container_name    = "${var.abpt_ecs_service_name}"
      container_port    = "${var.abpt_docker_container_port}"
      target_group_arn  = "${aws_alb_target_group.abpt_ecs_app_target_group.arn}" 
    }
}

resource "aws_alb_listener_rule" "abpt_ecs_alb_listener_rule" {
  listener_arn          = "${aws_alb_listener.abpt_ecs_https_listener.arn}"

  action {
      type              = "forward"
      target_group_arn  = "${aws_alb_target_group.abpt_ecs_app_target_group.arn}"
  }
  
  condition {
     host_header {
      values   = ["${lower(var.abpt_ecs_service_name)}.${data.aws_route53_zone.arca-blanca-ecsdomain.name}"]
      }
  }
}

resource "aws_cloudwatch_log_group" "abptapp_log_group" {
  name                                      = "${var.abpt_ecs_service_name}-LogGroup"
}
# testing another