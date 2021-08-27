resource "aws_ecr_repository" "openvpn" {
  name                 = "${var.project_name}-openvpn-${var.env}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
