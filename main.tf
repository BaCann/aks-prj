# Tạo Resource Group
resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "Demo"
    ManagedBy   = "Terraform"
  }
}

# Tạo Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.aks_rg.name
  location            = azurerm_resource_group.aks_rg.location
  sku                 = var.acr_sku
  admin_enabled       = false  # Dùng Managed Identity thay vì admin user

  tags = {
    Environment = "Demo"
    ManagedBy   = "Terraform"
  }
}

# Gán quyền cho AKS pull image từ ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

# Tạo AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = var.cluster_name
  kubernetes_version  = var.kubernetes_version

  # Cấu hình node pool mặc định
  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.vm_size
    
    # Enable auto-scaling (tùy chọn)
    # min_count  = 1
    # max_count  = 3
  }

  # Sử dụng System-assigned Managed Identity (đơn giản hơn Service Principal)
  identity {
    type = "SystemAssigned"
  }

  # Network Profile
  network_profile {
    network_plugin    = "kubenet"  # Đơn giản hơn Azure CNI
    load_balancer_sku = "standard"
  }

  tags = {
    Environment = "Demo"
    ManagedBy   = "Terraform"
  }
}