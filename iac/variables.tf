variable "subscription_id" {
  description = "The Azure subscription ID"
  type        = string
  default     = "d1bbe07c-713a-4149-8c8e-313060b62dd0"
}

variable "location" {
  description = "The Azure region"
  type        = string
  default     = "Norway East"
}

variable "resource_group_name" {
  description = "The Azure resource group name"
  type        = string
  default     = "msc-prod-rg"
}