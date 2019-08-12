variable "azure_subscription_id" {}
variable "azure_tenant_id" {}
variable "azure_client_id" {}
variable "client_certificate_path" {}
variable "client_certificate_password" {}

variable "azure_environment" {
  default = "public"
}

variable "environment"{
    default = "dev"
}

variable "region" {
  default = "us"
}

variable "prefix" {
  description = "This prefix will be included in the name of some resources."
  default     = "pbjenkdata"
}

variable "location" {
  description = "The region where the virtual network is created."
  default     = "eastus"
}

variable "location_key" {
  description = "The region where the virtual network is created."
  default     = "eus"
}