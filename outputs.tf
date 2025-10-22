output "resource_group_name" {
  description = "Resource Group Name"
  value       = azurerm_resource_group.aks_rg.name
}

output "cluster_name" {
  description = "AKS Cluster Name"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "cluster_id" {
  description = "ID of AKS Cluster"
  value       = azurerm_kubernetes_cluster.aks.id
}

output "kube_config" {
  description = "Kubernetes config"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}

output "get_credentials_command" {
  description = "Command credentials"
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.aks_rg.name} --name ${azurerm_kubernetes_cluster.aks.name}"
}

output "acr_name" {
  description = "Azure Container Registry Name"
  value       = azurerm_container_registry.acr.name
}

output "acr_login_server" {
  description = "Login server of ACR"
  value       = azurerm_container_registry.acr.login_server
}

output "acr_id" {
  description = "ACR ID"
  value       = azurerm_container_registry.acr.id
}
