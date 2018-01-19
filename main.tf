
resource "aws_iam_instance_profile" "foreman" {
  name = "foreman"
  role = "${aws_iam_role.foreman.name}"
}

resource "aws_iam_instance_profile" "basicServer" {
  name = "basicServer"
  role = "${aws_iam_role.basicServer.name}"
}

resource "aws_iam_instance_profile" "gitlab" {
  name = "gitlab"
  role = "${aws_iam_role.gitlab.name}"
}

resource "aws_iam_role" "foreman" {
  name = "foreman"

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

resource "aws_iam_role" "basicServer" {
    name               = "basicServer"
    path               = "/"
    assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role" "gitlab" {
    name               = "gitlab"
    path               = "/"
    assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = "${aws_iam_role.basicServer.name}"
  policy_arn = "${var.cloudwatch_policy_arn}"
}

resource "aws_iam_role_policy_attachment" "foreman-cloudwatch" {
  role       = "${aws_iam_role.foreman.name}"
  policy_arn = "${var.cloudwatch_policy_arn}"
}

resource "aws_iam_role_policy_attachment" "ec2_admin" {
  role       = "${aws_iam_role.foreman.name}"
  policy_arn = "${var.ec2_admin_policy_arn}"
}

resource "aws_iam_role_policy_attachment" "gitlab" {
  role       = "${aws_iam_role.gitlab.name}"
  policy_arn = "${var.cloudwatch_policy_arn}"
}

resource "aws_iam_role_policy_attachment" "gitlab-s3" {
  role       = "${aws_iam_role.gitlab.name}"
  policy_arn = "${var.gitlab_policy_arn}"
}
