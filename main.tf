resource "azurerm_resource_group" "networking_resource_group" {
  name     = "${local.full_prefix}_networking_rg"
  location = var.resource_groups_location

  tags = {
    Environment = var.env
  }
}

resource "azurerm_resource_group" "aks_resource_group" {
  name     = "${local.full_prefix}_aks_rg"
  location = var.resource_groups_location

  tags = {
    Environment = var.env
  }
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = "${local.full_prefix}_vnet"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.networking_resource_group.name
  location            = azurerm_resource_group.networking_resource_group.location

  tags = {
    Environment = var.env
  }
}

resource "azurerm_subnet" "subnet" {
  name                 = "${local.full_prefix}_subnet"
  resource_group_name  = azurerm_resource_group.networking_resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.0.2.0/24"]
}


resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
  name                    = "${local.full_prefix}_aks"
  location                = azurerm_resource_group.aks_resource_group.location
  resource_group_name     = azurerm_resource_group.aks_resource_group.name
  dns_prefix              = "${var.prefix}${var.env}"

  azure_active_directory_role_based_access_control {
    managed             = true
    azure_rbac_enabled  = true
  }

  default_node_pool {
    name       = "${var.prefix}${var.env}np"
    node_count = var.node_count
    vm_size    = var.node_pull_vm_size

    tags = {
      Environment = var.env
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = var.env
  }
}

resource "kubernetes_namespace" "ingress_namespace" {
  metadata {
    name = "ingress"
  }
}

resource "helm_release" "nginx_ingress" {
  depends_on = [kubernetes_namespace.ingress_namespace]
  name       = "ingress"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx"
  namespace  = kubernetes_namespace.ingress_namespace.metadata.0.name

  values = [templatefile("helm_values.yaml", {
    subnet_name = azurerm_subnet.subnet.name
  })]
}
