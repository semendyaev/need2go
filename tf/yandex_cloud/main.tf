terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}




provider "yandex" {
  token     = var.provider_token
  cloud_id  = var.provider_cloud_id
  folder_id = var.provider_folder_id
  zone      = "ru-central1-a"
}


resource "yandex_vpc_network" "network-1" {
  name = "network1"
}


resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["10.0.0.0/24"]
}

output "internal_ip_address_router1" {
  value = yandex_compute_instance.router1.network_interface.0.ip_address
}





output "external_ip_address_router1" {
  value = yandex_compute_instance.router1.network_interface.0.nat_ip_address
}

resource "yandex_vpc_route_table" "lab-rt-a" {
  name       = "default-internet"
  network_id = yandex_vpc_network.network-1.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.router1.network_interface.0.ip_address
  }
}

