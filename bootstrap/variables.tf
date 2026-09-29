variable "subscription_id" {
  description = "Azure Subscription ID used for the STC Tech Terraform Network Capstone"
  type        = string
  sensitive   = true
}

variable "current_user_object_id" {
  description = "Microsoft Entra Object ID of the user managing Terraform state"
  type        = string
  sensitive   = true
}