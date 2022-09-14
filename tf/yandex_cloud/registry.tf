resource "yandex_container_registry" "my-reg" {
  name = "need2go-registry"
  folder_id = var.provider_folder_id
  labels = {
    prod-label = "prod"
  }
}