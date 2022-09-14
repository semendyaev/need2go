resource "yandex_compute_instance" "router1" {
  name = "router1"
  platform_id = "standard-v2"

  resources {
    cores  = 2
    memory = 1
    core_fraction = 5     // 5% guatanteed perfomance (vCPU)
  }

  boot_disk {
    initialize_params {
      image_id = "fd8phfma88csn6br814r"
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
    user-data = "${file("./meta.txt")}${file("./meta-cmd.txt")}"
  }
}
