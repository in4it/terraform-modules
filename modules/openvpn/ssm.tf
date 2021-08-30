module "ssm-parameters-vpn" {
  source = "git@github.com:in4it/terraform-modules.git//modules/ssm-parameters"
  prefix = "/${var.project_name}-${var.env}/vpn/"
  parameters = [
    {
      "name"  = "ONELOGIN-CLIENT-ID"
      "value" = var.onelogin_client_id
      "type"  = "SecureString"
    },
    {
      "name"  = "ONELOGIN-CLIENT-SECRET"
      "value" = var.onelogin_client_secret
      "type"  = "SecureString"
    },
    {
      "name"  = "OAUTH2_REDIRECT_URL"
      "value" = "https://vpn-app.${var.domain}/callback"
      "type"  = "SecureString"
    },
    {
      "name"  = "OAUTH2_URL"
      "value" = var.onelogin_oauth_url
      "type"  = "SecureString"
    },
    {
      "name"  = "OAUTH2_SCOPES"
      "value" = "openid name profile groups email params phone"
      "type"  = "SecureString"
    },
    {
      "name"  = "CLIENT_CERT_ORG"
      "value" = var.organization_name
      "type"  = "SecureString"
    },
    {
      "name"  = "ONELOGIN-CLIENT-ID"
      "value" = ""
      "type"  = "SecureString"
    },
    {
      "name"  = "ONELOGIN-CLIENT-SECRET"
      "value" = ""
      "type"  = "SecureString"
    }
  ]
}

