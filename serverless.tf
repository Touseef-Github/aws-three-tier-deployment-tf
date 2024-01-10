resource "aws_s3_bucket" "Storage-Bucket" {
  bucket = "Infra-sotrage-testing123"
  acl    = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket" "Storage-Bucket2" {
  bucket = "Infra-sotrage-testing12345"
  acl    = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# SNS Topics
resource "aws_sns_topic" "code_deployment_approval_request" {
  name        = "CodeDeploymentInfinity-SendApprovalRequest"
  display_name = "CodeDeploymentInfinity-SendApprovalRequest"
}

# SQS Queue
resource "aws_sqs_queue" "infinity_courier_dlq" {
  name                      = "Infinity-CourierDeliveredNotificationSQS-DLQ-${var.environment}"
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 345600
  visibility_timeout_seconds = 31
  receive_wait_time_seconds = 0

  redrive_policy = jsonencode({
    deadLetterTargetArn    = aws_sns_topic.code_deployment_approval_request.arn
    maxReceiveCount        = 5
    maxReceiveCountPerQueue = 5
  })

  kms_master_key_id = "alias/aws/sqs"
  kms_data_key_reuse_period_seconds = 300
}
##########Cognito user pool client pool##############

resource "aws_cognito_user_pool" "test_app_user_pool" {
  name                      = "${var.environment}_testApp"
  password_policy {
    minimum_length          = 8
    temporary_password_validity_days = 30
  }
  username_configuration {
    case_sensitive = false
  }

  schema {
    name     = "email"
    attribute_data_type      = "String"
    required = true
    mutable  = true
  }

  schema {
    name     = "username"
    mutable  = true
    attribute_data_type      = "String"
  }

  schema {
    name     = "client_otp_value"
    mutable  = true
    attribute_data_type      = "String"
    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    name     = "otp_generated_at"
    mutable  = true
    attribute_data_type      = "String"
    string_attribute_constraints {
      min_length = 1
      max_length = 25
    }
  }

  schema {
    name     = "otp_invalid_count"
    mutable  = true
    attribute_data_type      = "String"
    string_attribute_constraints {
      min_length = 1
      max_length = 100
    }
  }

  schema {
    name     = "otp_key"
    mutable  = true
    attribute_data_type      = "String"
    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    name     = "privacy_terms"
    attribute_data_type      = "String"
    mutable  = true
    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    name     = "temp_blocked_at"
    attribute_data_type      = "String"
    mutable  = true
    string_attribute_constraints {
      min_length = 1
      max_length = 25
    }
  }

  schema {
    name     = "timezone_offset"
    attribute_data_type      = "String"
    mutable  = true
    string_attribute_constraints {
      min_length = 1
      max_length = 50
    }
  }

  schema {
    name     = "user_role_name"
    attribute_data_type      = "String"
    mutable  = true
    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  auto_verified_attributes = []

  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "admin_only"
      priority = 1
    }
  }
}

resource "aws_cognito_user_pool_client" "test_app_user_pool_client" {
  name                   = "${var.environment}_test_client"
  generate_secret        = false
  user_pool_id           = aws_cognito_user_pool.test_app_user_pool.id
  allowed_oauth_flows_user_pool_client = true
  explicit_auth_flows    = [
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH",
  ]
  access_token_validity   = 60
  id_token_validity       = 60
  refresh_token_validity  = 30
  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }
  prevent_user_existence_errors = "ENABLED"
}



##########Cognito Identity$$$$$$$$$$
resource "aws_cognito_identity_pool" "global_identity_pool" {
  identity_pool_name             = "${var.environment}_swipbox_identity_clone"
  allow_classic_flow             = false
  allow_unauthenticated_identities = true

  cognito_identity_providers {
      client_id     = aws_cognito_user_pool_client.test_app_user_pool_client.id
      provider_name = aws_cognito_user_pool.test_app_user_pool.endpoint
    }
}

resource "aws_cognito_identity_pool_roles_attachment" "identity_pool_role_attachment" {
  identity_pool_id = aws_cognito_identity_pool.global_identity_pool.id

  roles = {
    authenticated   = aws_iam_role.authenticated_role.arn
    unauthenticated = aws_iam_role.unauthenticated_role.arn
  }
}

resource "aws_iam_role" "authenticated_role" {
  name = "AuthenticatedRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "cognito-identity.amazonaws.com"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "cognito-identity.amazonaws.com:aud" = aws_cognito_identity_pool.global_identity_pool.id
          }
        }
      }
    ]
  })

  inline_policy {
    name = "Cognito-AuthenticatedPolicy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "cognito-identity:GetCredentialsForIdentity",
            "mobileanalytics:PutEvents",
            "cognito-sync:*",
            "cognito-identity:*",
            "s3:ListBucket",
            "s3:GetObject",
            "s3:PutObject",
            "s3-object-lambda:*",
          ],
          Resource = ["*"]
        }
      ]
    })
  }
}

resource "aws_iam_role" "unauthenticated_role" {
  name = "UnauthenticatedRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "cognito-identity.amazonaws.com"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "cognito-identity.amazonaws.com:aud" = aws_cognito_identity_pool.global_identity_pool.id
          }
        }
      }
    ]
  })

  inline_policy {
    name = "Cognito-UnauthenticatedPolicy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "cognito-identity:GetCredentialsForIdentity",
            "mobileanalytics:PutEvents",
            "cognito-sync:*",
            "cognito-identity:*",
            "s3:ListBucket",
          ],
          Resource = ["*"]
        }
      ]
    })
  }
}
