resource "aws_iam_role" "CSYE6225-ami-infrastructure" {
  name = "CSYE6225-ami-infrastructure"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "root-access" {
  name        = "root-access"
  description = "root access policy"

  policy = <<EOT
{
   "Type": "AWS::IAM::Policy",
    "Properties": {
        "PolicyName": "root",
        "PolicyDocument": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Action": "*",
                    "Resource": "*"
                }
            ]
        },
        "Roles": [
            {
                "Ref": "RootRole"
            }
        ]
    }
}
EOT
}

resource "aws_iam_instance_profile" "CSYE6225-ami-infrastructure" {
  name = "CSYE6225-ami-infrastructure"
  role = "${aws_iam_role.CSYE6225-ami-infrastructure.name}"
}

resource "aws_iam_policy_attachment" "role-attach" {
  name       = "role-attachment"
  users = [ "ghactions-ami" ]
  roles      = [aws_iam_role.CSYE6225-ami-infrastructure.name]
  policy_arn = aws_iam_policy.root-access.arn
}