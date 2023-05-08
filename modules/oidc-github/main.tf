// Copyright © 2021 Daniel Morris
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at:
//
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// 
// 
// Modifications copyright (C) 2023 Vasilis Siourdas

locals {
  github_organizations = toset([for repo in var.github_repositories : split("/", repo)[0]])
  oidc_provider_arn    = aws_iam_openid_connect_provider.github.arn
  partition            = data.aws_partition.current.partition
}

resource "aws_iam_role" "github" {
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  description          = "Role assumed by the GitHub OIDC provider."
  max_session_duration = var.max_session_duration
  name                 = var.iam_role_name
  tags                 = var.tags

  dynamic "inline_policy" {
    for_each = var.iam_role_inline_policies

    content {
      name   = inline_policy.key
      policy = inline_policy.value
    }
  }
}

resource "aws_iam_role_policy_attachment" "custom" {
  count = length(var.iam_role_policy_arns)

  policy_arn = var.iam_role_policy_arns[count.index]
  role       = aws_iam_role.github.id
}

resource "aws_iam_openid_connect_provider" "github" {
  client_id_list = concat(
    [for org in local.github_organizations : "https://github.com/${org}"],
    ["sts.amazonaws.com"]
  )

  tags            = var.tags
  url             = "https://token.actions.githubusercontent.com"
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
}
