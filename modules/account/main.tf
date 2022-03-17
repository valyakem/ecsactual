resource "aws_organizations_account" "pricingtool-arcablanca" {
  name      = "${var.name}"
  email     = "${var.email}"
  role_name = "${var.role_name}"
  iam_user_access_to_billing  = "${var.iam_user_access_to_billing}"
  parent_id = "${var.parent_id}"

  # There is no AWS Organizations API for reading role_name change region
  lifecycle {
    ignore_changes = [role_name]
  }
}