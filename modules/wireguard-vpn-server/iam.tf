resource "aws_iam_instance_profile" "vpn-server" {
  name = "vpn-server-iam-instance-profile-${var.env}"
  role = aws_iam_role.vpn-server-iam-role.name
}

resource "aws_iam_role" "vpn-server-iam-role" {
  name = "vpn-server-iam-role-${var.env}"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "vpn-iam-policy-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.vpn-server-iam-role.id
}