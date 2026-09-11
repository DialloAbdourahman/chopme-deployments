resource "aws_iam_user" "this" {
  name = var.name

  tags = var.tags
}

resource "aws_iam_user_policy_attachment" "this" {
  count = length(var.policy_arns)

  user       = aws_iam_user.this.name
  policy_arn = var.policy_arns[count.index]
}

resource "aws_iam_user_policy" "this" {
  for_each = var.inline_policies

  name   = each.key
  user   = aws_iam_user.this.name
  policy = each.value
}
