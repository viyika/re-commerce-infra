resource "azurerm_resource_group" "example" {
  name     = "re-commerce"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "example" {
  name                = "recommerce-app-plan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  kind                = "linuk"

  sku {
    tier = "Standard"
    size = "S1"
  }

  tags = {}
}

resource "azurerm_app_service" "example" {
  name                = "recommerce-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  site_config {
    health_check_path       = "/actuator/health"
    linux_fx_version        = "COMPOSE|${filebase64("compose.yml")}"
    cors {
        allowed_origins     = ["*"]
        support_credentials = true
    }
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}