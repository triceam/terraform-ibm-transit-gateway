module "resource_group" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-resource-group.git"

  resource_group_name = "tg-test-resource-group"
  ibmcloud_api_key    = var.ibmcloud_api_key
  provision           = true
}
