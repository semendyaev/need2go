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
  cloud_id  = "b1gpl23qnciqb7mn4a3h"
  folder_id = "b1glvge9on9gb5kn8nee"
  zone      = "ru-central1-a"
}




resource "yandex_compute_instance" "vm-1" {
  name = "pg1"
  platform_id = "standard-v2"

  resources {
    cores  = 2
    memory = 1
    core_fraction = 5     // 5% guatanteed perfomance (vCPU)
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ofg98ci78v262j491"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  scheduling_policy {
    preemptible = true    // interrupted vm cheaper
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}





resource "yandex_compute_instance" "vm-2" {
  name = "pg2"
  platform_id = "standard-v2"

  resources {
    cores  = 2
    memory = 0.5
    core_fraction = 5     // 5% guatanteed perfomance (vCPU)
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ofg98ci78v262j491"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  scheduling_policy {
    preemptible = true    // interrupted vm cheaper
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}





resource "yandex_vpc_network" "network-1" {
  name = "network1"
}





resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}





output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}





output "internal_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.ip_address
}





output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}




output "external_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
}

