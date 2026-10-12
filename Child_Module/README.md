# Azure Landing Zone (ALZ) Terraform Child Modules Catalog

This repository contains reusable Terraform child modules designed to implement an Enterprise **Azure Landing Zone (ALZ)** based on the **Microsoft Cloud Adoption Framework (CAF)**.

---

## Module Inventory & CAF Design Areas

### 1. Management Groups & Governance (Core Platform Hierarchy)
- **[`azurerm_management_group`](./azurerm_management_group)**: Creates hierarchical management groups (`Platform`, `Landing Zones`, `Sandboxes`, `Decommissioned`) under the Tenant/Intermediate root.
- **[`azurerm_policy_assignment`](./azurerm_policy_assignment)**: Assigns Azure Policy definitions and initiatives at Management Group and Subscription scopes, with managed identity support for automated remediations.
- **[`azurerm_role_assignment`](./azurerm_role_assignment)**: Manages RBAC role assignments and custom role definitions scoped to Management Groups, Subscriptions, or Resource Groups.

### 2. Network Topology & Connectivity (Connectivity Landing Zone)
- **[`azurerm_virtual_network`](./azurerm_virtual_network)**: Provisions Hub and Spoke virtual networks.
- **[`azurerm_subnet`](./azurerm_subnet)**: Creates subnets with service endpoints and delegations.
- **[`azurerm_vnet_peering`](./azurerm_vnet_peering)**: Manages bidirectional Hub-to-Spoke VNet peering.
- **[`azurerm_route_table`](./azurerm_route_table)**: **(Critical ALZ Component)** Defines User-Defined Routes (UDR) to force Spoke and egress traffic through Azure Firewall (`0.0.0.0/0 -> NextHop: Firewall IP`) and associates them with subnets.
- **[`azurerm_firewall`](./azurerm_firewall)**: Provisions Azure Firewall in the Hub network.
- **[`azurerm_firewall_policy`](./azurerm_firewall_policy)**: Modern ALZ firewall policy engine with Network, Application, and NAT Rule Collection Groups.
- **[`azurerm_virtual_network_gateway`](./azurerm_virtual_network_gateway)**: VPN and ExpressRoute Gateways for hybrid on-premises connectivity in `GatewaySubnet`.
- **[`azurerm_bastion`](./azurerm_bastion)**: Secure, clientless RDP/SSH jump host in `AzureBastionSubnet`.
- **[`azurerm-application-gateway`](./azurerm-application-gateway)**: Layer 7 reverse proxy, SSL termination, and WAF.
- **[`azurerm_private_dns_zone`](./azurerm_private_dns_zone)**: Centralized private DNS zones (`privatelink.blob.core.windows.net`, `privatelink.vaultcore.azure.net`, etc.) linked to Hub and Spoke VNets.
- **[`azurerm_private_endpoint`](./azurerm_private_endpoint)**: Private Endpoints with DNS Zone Group integration for securing PaaS services.
- **[`azurerm_public_ip`](./azurerm_public_ip)**: Standard public IP addresses.
- **[`azurerm_NetworkInterface`](./azurerm_NetworkInterface)**: Network interfaces for VMs.
- **[`azurerm_Network_Security_Group`](./azurerm_Network_Security_Group)**: L4 security rules and associations.

### 3. Management, Operations & BCDR (Management Landing Zone)
- **[`azurerm_monitoring`](./azurerm_monitoring)**: Central Log Analytics Workspace and Diagnostic Settings.
- **[`azurerm_recovery_services_vault`](./azurerm_recovery_services_vault)**: Centralized backup vault and VM backup policies for disaster recovery.

### 4. Workloads & Application Landing Zones
- **[`azurerm_resource_group`](./azurerm_resource_group)**: Resource groups with tagging standards.
- **[`azurerm_virtual_machines`](./azurerm_virtual_machines)**: Workload compute instances.
- **[`azurerm_storage_account`](./azurerm_storage_account)**: Secure storage accounts for boot diagnostics, files, or blobs.
- **[`azurerm_keyvault`](./azurerm_keyvault)**: Azure Key Vault for certificates, keys, and secrets.
- **[`azurerm_vm_secrets`](./azurerm_vm_secrets)**: Automatic generation and storage of credentials in Key Vault.
- **[`azurerm_kubernetes_cluster`](./azurerm_kubernetes_cluster)**: Managed AKS clusters with Azure CNI and RBAC.
- **[`azurerm_container_registry`](./azurerm_container_registry)**: Secure private container registry (ACR) for containerized workloads.

---

## Example Usage: Wiring Route Table (UDR) to Force Spoke Traffic to Firewall

```hcl
module "route_table" {
  source = "../../Child_Module/azurerm_route_table"

  route_tables = {
    spoke_to_fw = {
      name     = "rt-spoke-to-firewall"
      location = "eastus"
      rg_name  = "hub-and-spoke-rg"
      routes = [
        {
          name                   = "route-all-traffic-to-hub-firewall"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.0.0.4" # Azure Firewall Private IP
        }
      ]
    }
  }

  route_table_associations = {
    frontend_assoc = {
      subnet_name     = "frontendsubnet"
      vnet_name       = "spokevnet1"
      rg_name         = "hub-and-spoke-rg"
      route_table_key = "spoke_to_fw"
    }
    backend_assoc = {
      subnet_name     = "backendsubnet"
      vnet_name       = "spokevnet1"
      rg_name         = "hub-and-spoke-rg"
      route_table_key = "spoke_to_fw"
    }
  }

  depends_on = [module.subnet, module.firewall]
}
```
