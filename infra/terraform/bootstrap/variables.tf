variable "project" {
  description = "Nome do projeto, usado como prefixo dos recursos."
  type        = string
  default     = "credit-risk-mlops"
}

variable "aws_region" {
  description = "Região AWS dos recursos."
  type        = string
  default     = "us-east-1"
}

variable "monthly_budget_usd" {
  description = "Teto mensal de gasto na conta de estudo, em USD."
  type        = number
  default     = 10

  validation {
    condition     = var.monthly_budget_usd > 0
    error_message = "O budget mensal precisa ser maior que zero."
  }
}

variable "budget_alert_email" {
  description = "E-mail que recebe os alertas de budget."
  type        = string
}
