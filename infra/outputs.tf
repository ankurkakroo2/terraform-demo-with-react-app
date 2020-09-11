##################################################################################
# OUTPUT
##################################################################################

#output "aws_elb_public_dns" {
#  value = aws_elb.web.dns_name
#}

#output "cname_record_url" {
#  value = "http://${local.env_name}-website.${var.dns_zone_name}"
#}

##############################################

# output "ecr_arn" {
#   value = aws_ecr_repository.registry.arn
# }


# output "ecr_repository" {
#   value = aws_ecr_repository.registry.repository_url
# }

output "environment_url" {
  value = module.lb.environment_url
}
