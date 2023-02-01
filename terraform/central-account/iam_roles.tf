data "aws_iam_policy_document" "consoleme_user_deny_all" {
  statement {
    sid       = "ConsoleMeWillAssumeThis"
    effect    = "Deny"
    resources = ["*"]
    actions = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy" "consoleme_user_role_policy1" {
  name   = "ConsoleMeTargetPolicy"
  role   = aws_iam_role.consoleme_example_user_role_1.id
  policy = data.aws_iam_policy_document.consoleme_user_deny_all.json
}

resource "aws_iam_role_policy" "consoleme_user_role_policy2" {
  name   = "ConsoleMeTargetPolicy"
  role   = aws_iam_role.consoleme_example_user_role_2.id
  policy = data.aws_iam_policy_document.consoleme_user_deny_all.json
}

resource "aws_iam_role_policy" "consoleme_app_role_policy1" {
  name   = "ConsoleMeTargetPolicy"
  role   = aws_iam_role.consoleme_example_app_role_1.id
  policy = data.aws_iam_policy_document.consoleme_user_deny_all.json
}

resource "aws_iam_role_policy" "consoleme_app_role_policy2" {
  name   = "ConsoleMeTargetPolicy"
  role   = aws_iam_role.consoleme_example_app_role_2.id
  policy = data.aws_iam_policy_document.consoleme_user_deny_all.json
}

data "aws_iam_policy_document" "consoleme_user_trust_policy" {
  statement {
    sid = "ConsoleMeCanAssumeAllRoles"
    actions = [
    "sts:AssumeRole"]
    effect = "Allow"
    principals {
      identifiers = [
      aws_iam_role.ConsoleMeInstanceProfile.arn]
      type = "AWS"
    }
  }
}

resource "aws_iam_role" "consoleme_example_user_role_1" {
  name               = "ConsoleMeUserA"
  assume_role_policy = data.aws_iam_policy_document.consoleme_target_trust_policy.json
  tags = {
    consoleme-authorized = "consoleme_admins@planetariumhq.com"
  }
}

resource "aws_iam_role" "consoleme_example_user_role_2" {
  name               = "ConsoleMeUserB"
  assume_role_policy = data.aws_iam_policy_document.consoleme_target_trust_policy.json
  tags = {
    consoleme-authorized = "configeditors@planetariumhq.com:consoleme_admins@planetariumhq.com"
  }
}


resource "aws_iam_role" "consoleme_example_app_role_1" {
  name               = "ConsoleMeAppA"
  assume_role_policy = data.aws_iam_policy_document.consoleme_target_trust_policy.json
  tags = {
    consoleme-authorized-cli-only = "groupa@planetariumhq.com"
  }
}

resource "aws_iam_role" "consoleme_example_app_role_2" {
  name               = "ConsoleMeAppB"
  assume_role_policy = data.aws_iam_policy_document.consoleme_target_trust_policy.json
  tags = {
    consoleme-authorized-cli-only = "groupa@planetariumhq.com:groupb@planetariumhq.com"
  }
}