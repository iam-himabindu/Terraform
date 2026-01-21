variable "lambda_role_name" {
  description = "IAM role name for Lambda"
  type        = string
  default     = "lambda_execution_role"
}

variable "lambda_basic_policy_arn" {
  description = "AWS managed policy for Lambda basic execution"
  type        = string
  default     = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

variable "lambda_function_name" {
  description = "Lambda function name"
  type        = string
  default     = "test_lambda_function"
}

variable "lambda_handler" {
  description = "Lambda handler"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "lambda_runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "python3.12"
}

variable "lambda_timeout" {
  description = "Lambda timeout in seconds"
  type        = number
  default     = 900
}

variable "lambda_memory" {
  description = "Lambda memory size in MB"
  type        = number
  default     = 128
}

variable "lambda_zip_file" {
  description = "Path to Lambda ZIP file"
  type        = string
  default     = "lambda_function.zip"
}
