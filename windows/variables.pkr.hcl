variable "client_id" {
  type      = string
  sensitive = true
}

variable "client_secret" {
  type      = string
  sensitive = true
}

variable "subscription_id" {
  type      = string
  sensitive = true
}

variable "tenant_id" {
  type      = string
  sensitive = true
}

variable "resource_group_name" {
  type = string
}

variable "image_offer" {
  type = string
}

variable "image_publisher" {
  type = string
}

variable "image_sku" {
  type = string
}
