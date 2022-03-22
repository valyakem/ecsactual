output "vpc_id" {
    value                   = "${aws_vpc.arca-blanca-ptvpc.id}" 
}

output "vpc_cidr_block" {
   value                    = "${var.vpc_cidr}" 
}

output "ecs_alb_listener_arn" {
    value                   = "${aws_alb_listener.abpt_https_listener.arn}"
}

output "cluster_name" {
  value                     = "${aws_ecs_cluster.arca-blanca-fargate-cluster.name}"
}

output "ecs_cluster_role_name" {
  value                     = "${aws_iam_role.abpt_ecs_cluster_role.name}"
}   

output "ecs_cluster_role_arn" {
  value                     = "${aws_iam_role.abpt_ecs_cluster_role.arn}"
}

output "ecs_domain_name" {
  value                     = "${var.ecs_arcablanca_domain}"
}   

output "ecs_public_subnets" {
  value                     = "${aws_alb.arca-blanca-ecs-cluster_alb.subnets}" 
}   

output "ecs_private_subnets" {
  value                     = "${var.private_subnetslist}"
}