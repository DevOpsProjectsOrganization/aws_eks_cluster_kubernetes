resource "aws_iam_role" "main" {
    name = "${var.name}-role"
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
}
resource "aws_iam_role_policy" "main_policy" {
   name = "${var.name}-role_policy"
   role = aws_iam_role.main.name
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
resource "aws_iam_instance_profile" "main" {
  name =  "${var.name}-ec2-role"
  role = aws_iam_role.main.name
}