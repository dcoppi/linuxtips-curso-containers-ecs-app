resource "aws_aim_role" "main" {
    name = format("%s-role", var.service_name)

    assume_role_policy = jsonencode ({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Principal = {
                    Service = "ecs-tasks.amazonaws.com"
                }
                Effect = "Allow"
                Sid = ""
            },
        ]
    })
}

resource "aws_iam_role_policy" "service_execution_role" {
    name = format("%s-policy", var.service_name)
    role = aws_aim_role.main.id

    policy = jsonencode ({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "logs:CreateLogStream",
                    "logs:PutLogEvents",
                    "logs:CreateLogGroup",
                    "ecr:GetAuthorizationToken",
                    "ecr:BatchCheckLayuerAvailability",
                    "ecr:GetDownloadUrlForLayer",
                    "ecr:BatchGetImage",
                    "s3:GetObject",
                    "sqs:*"
                ],
                Effect = "Allow"
                Resource = "*"
            },
        ]
    })
}