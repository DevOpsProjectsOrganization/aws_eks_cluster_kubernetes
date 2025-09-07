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

}
resource "aws_iam_instance_profile" "main" {
  name =  "${var.name}-${var.env}-ec2-role"
  role = aws_iam_role.main.name
}