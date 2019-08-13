provider "azurerm" {
  environment                   = "${var.azure_environment}"
  subscription_id               = "${var.azure_subscription_id}"
  client_id                     = "${var.azure_client_id}"
  client_certificate_path       = "${var.client_certificate_path}"
  client_certificate_password   = "${var.client_certificate_password}"
  tenant_id                     = "${var.azure_tenant_id}"
}

resource "azurerm_resource_group" "grp" {
  name     = "jenkins-data-group"
  location = "${var.location}"
}

resource "azurerm_storage_account" "storage-account" {
  name                     = "${var.prefix}sa"
  resource_group_name      = "${azurerm_resource_group.grp.name}"
  location                 = "${azurerm_resource_group.grp.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "jenkinsshare" {
  name                 = "jenkins"
  storage_account_name = "${azurerm_storage_account.storage-account.name}"
  quota                = 20
}

resource "azurerm_storage_share" "vaultshare" {
  name                 = "vault"
  storage_account_name = "${azurerm_storage_account.storage-account.name}"
  quota                = 20
}

resource "azurerm_storage_share_directory" "vaultdirconfig" {
  name                 = "config"
  share_name           = "${azurerm_storage_share.vaultshare.name}"
  storage_account_name = "${azurerm_storage_account.storage-account.name}"

  provisioner "file" {
    source      = "vault.json"
    destination = "/config/vault.json"
  }

}

resource "azurerm_storage_share_directory" "vaultdirfile" {
  name                 = "file"
  share_name           = "${azurerm_storage_share.vaultshare.name}"
  storage_account_name = "${azurerm_storage_account.storage-account.name}"
}

resource "azurerm_storage_share_directory" "vaultdirlogs" {
  name                 = "logs"
  share_name           = "${azurerm_storage_share.vaultshare.name}"
  storage_account_name = "${azurerm_storage_account.storage-account.name}"
}

data "azurerm_storage_account" "data-storage-account" {
  name                = "${azurerm_storage_account.storage-account.name}"
  resource_group_name = "${azurerm_resource_group.grp.name}"
}

output "storage_primary_access_key" {
  value = "${data.azurerm_storage_account.data-storage-account.primary_access_key}"
}