resource "azurerm_resource_group" "example" {
  name          =   "re-commerce-rg01"
  location      =   "West Europe"
}

resource "azurerm_container_app_environment" "example" {
  name                       =  "re-commerce-env"
  location                   =  azurerm_resource_group.example.location
  resource_group_name        =  azurerm_resource_group.example.name
}

resource "azurerm_container_app" "example" {
  name                         =    "re-commerce-api"
  container_app_environment_id =    azurerm_container_app_environment.example.id
  resource_group_name          =    azurerm_resource_group.example.name
  revision_mode                =    "Single"
  
  secret {
    name        =   "ghcr"
    value       =   var.ghcr_token
  }
  
  registry {
    server      =   "ghcr.io"
    username    =   "samitkumarpatel"
    password_secret_name = "ghcr"
  }
  
  template {
    container {
        name          =   "re-commerce-api"
        image         =   "ghcr.io/viyika/re-commerce-api:090920231944"
        cpu           =   0.25
        memory        =   "0.5Gi"
        # liveness_probe {
        #     path        =   "/actuator/health/liveness"
        #     port        =   8080
        #     transport   =   "TCP"
        # }
        # readiness_probe {
        #     path        =   "/actuator/health/readiness"
        #     port        =   8080
        #     transport   =   "TCP"
        # }
        env {
            name        =   "DB_URI"
            value       =   var.db_uri
        }
    }
  }

  ingress {
    allow_insecure_connections  = true
    external_enabled            = true
    target_port                 = 8080
    traffic_weight {
        percentage              = 100
    }
  }
}