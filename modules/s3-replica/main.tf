terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.40.0"
      configuration_aliases = [ aws.source, aws.destination ]
    }
  }
}
