variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
  default     = "rg-aks-demo"
}

variable "location" {
  description = "Azure Region"
  type        = string
  default     = "Japan East"  
}

variable "cluster_name" {
  description = "AKS Cluster Name"
  type        = string
  default     = "aks-demo-cluster"
}

variable "kubernetes_version" {
  description = "Kubernetes Version"
  type        = string
  default     = "1.31.11"
}

variable "node_count" {
  description = "Nodes in Cluster"
  type        = number
  default     = 2  
}

variable "vm_size" {
  description = "VM Type for Nodes"
  type        = string
  default     = "Standard_B2s"  
}

variable "acr_name" {
  description = "Azure Container Registry Name"
  type        = string
  default     = "bacanacr0132"  
}

variable "acr_sku" {
  description = "SKU of ACR (Basic, Standard, Premium)"
  type        = string
  default     = "Basic"
}
