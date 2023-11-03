terraform {
  required_version = ">= 1.6.2"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.78.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.3"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config.0.host
    username               = azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config.0.username
    password               = azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config.0.password
    client_key             = base64decode(azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config.0.client_key)
    client_certificate     = base64decode(azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config.0.client_certificate)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config.0.cluster_ca_certificate)
  }
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config.0.host
  username               = azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config.0.username
  password               = azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config.0.password
  client_key             = base64decode(azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config.0.client_key)
  client_certificate     = base64decode(azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config.0.client_certificate)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config.0.cluster_ca_certificate)
}

provider "kubectl" {
  host                   = azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config.0.host
  username               = azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config.0.username
  password               = azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config.0.password
  client_key             = base64decode(azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config.0.client_key)
  client_certificate     = base64decode(azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config.0.client_certificate)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config.0.cluster_ca_certificate)
}