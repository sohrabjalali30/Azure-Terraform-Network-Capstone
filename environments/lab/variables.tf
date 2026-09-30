variable "subscription_id" {
  description = "Azure Subscription ID for the STC Tech network lab"
  type        = string
  sensitive   = true
}

variable "location" {
  description = "Primary Azure region for the network lab"
  type        = string
  default     = "UAE North"
}