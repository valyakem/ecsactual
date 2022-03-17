# resource "aws_organizations_account" "pricingtool-arcablanca" {
#   name      = "pricingtool-arcablanca"
#   email     = "valentine.akem@nexgbits.com"
#   role_name = "AWSControlTowerAdmin"
#   iam_user_access_to_billing  = "ALLOW"
#   parent_id = "r-tjwo"

#   # There is no AWS Organizations API for reading role_name change region
#   lifecycle {
#     ignore_changes = [role_name]
#   }
# }