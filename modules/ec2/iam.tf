resource "aws_iam_role" "main" {
    name = "${var.name}-${var.env}-role"
    assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
        {
        "Effect" : "Allow",
        "Principal" : {
            "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
        }
     ]
    })
    inline_policy {
    name = "inline"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = local.iam_policy
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }

}