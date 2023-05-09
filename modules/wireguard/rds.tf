module "vpn-rds" {
  source         = "github.com/in4it/terraform-modules//modules/rds"
  name           = "vpn"
  storage        = "20"
  storage_type   = "gp2"
  engine         = "postgres"
  engine_family  = "postgres15"
  engine_version = "15.2"
  username       = "vpn"
  database_name  = "vpn"
  vpc_id         = var.vpc_id
  instance_type  = var.db_instance_type
  subnet_group   = ""
}
