resource "aws_s3_bucket" "storage_bucket" {
  bucket = "touseef-test-storage-bucket-1234"  # Set a globally unique bucket name
  acl    = "private"  # Access control for the bucket. Options: private, public-read, public-read-write, authenticated-read, log-delivery-write, bucket-owner-read, bucket-owner-full-control
  force_destroy = true  # Set to true to allow Terraform to destroy the bucket even if it contains objects
  tags = {
    Name        = "storage_bucket"
    Environment = "Dev"
  }
}

# ###########Second S3 bucket #######

resource "aws_s3_bucket" "storage_bucket2" {
  bucket = "touseef-test-storage-bucket-12345"  # Set a globally unique bucket name
  acl    = "private"  # Access control for the bucket. Options: private, public-read, public-read-write, authenticated-read, log-delivery-write, bucket-owner-read, bucket-owner-full-control
  force_destroy = true  # Set to true to allow Terraform to destroy the bucket even if it contains objects
  tags = {
    Name        = "storage_bucket2"
    Environment = "prod"
  }
}

##### SNS Topics#########
resource "aws_sns_topic" "code_deployment_approval_request" {
  name        = "CodeDeploymentInfinity-SendApprovalRequest"
  display_name = "CodeDeploymentInfinity-SendApprovalRequest"
}

# # SQS Queue
resource "aws_sqs_queue" "Test-sqs1" {
  name                      = "Test-sqs1-${var.environment}"
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 345600
  visibility_timeout_seconds = 31
  receive_wait_time_seconds = 1
  tags = {
    Environment = "production"
  }
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

  callback_urls = ["https://web.tradelinx.onlnie/callback"]
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