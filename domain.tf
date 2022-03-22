resource "aws_acm_certificate" "arca-blanca-domaincert" {
    domain_name                     = "*.${var.ecs_arcablanca_domain}"
    validation_method               ="DNS"

    tags = {
        name                        = "${var.ecs_arcablanca_domain}-certificate"
    }
}

data "aws_route53_zone" "arca-blanca-ecsdomain" {
    name                            = "${var.ecs_arcablanca_domain}" 
    private_zone                    = false 
}


resource "aws_route53_record" "abpt_ecs_cert_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.arca-blanca-domaincert.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = dvo.domain_name == "nexgbit.academy" ? data.aws_route53_zone.arca-blanca-ecsdomain.zone_id : data.aws_route53_zone.arca-blanca-ecsdomain.zone_id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}
# resource "aws_route53_record" "abpt_ecs_cert_validation_record" {
#     name                            = "${tolist(aws_acm_certificate.arca-blanca-domaincert.domain_validation_options)[0].resource_record_name}" 
#     type                            = "${tolist(aws_acm_certificate.arca-blanca-domaincert.domain_validation_options)[0].resource_record_type}"
#     zone_id                         = "${data.aws_route53_zone.arca-blanca-ecsdomain.zone_id}" 
#     records                         = ["${tolist(aws_acm_certificate.arca-blanca-domaincert.domain_validation_options)[0].resource_record_value}"]
#     ttl                             = 60
# }

#Adding the actual certificate to aws
resource "aws_acm_certificate_validation" "abpt_domaincert_validation" {
    certificate_arn                  = "${aws_acm_certificate.arca-blanca-domaincert.arn}" 
    validation_record_fqdns          = ["${aws_route53_record.abpt_ecs_cert_validation_record.fqdn}"]    
}

