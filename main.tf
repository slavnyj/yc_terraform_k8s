terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

#Сhange the section below
provider "yandex" {
  token     = "token"
  cloud_id  = "cloud_id"
  folder_id = "folder_id"
  zone      = "ru-central1-b"
}

resource "yandex_compute_instance" "vm-1" {
  name        = "terraform1"
  platform_id = "standard-v2"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8vmcue7aajpmeo39kk" //ubuntu-2004-lts
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    #user-data = "${file("C:\\Users\\iec_000\\yandex-cloud-terraform\\cloud-config.txt")}" - from Windows OS
    user-data = "${file("/Users/ivanov1/Projects/yc_terraform_k8s/cloud-config.txt")}" #for MacOS of Linux
  }
}


resource "yandex_compute_instance" "vm-2" {
  name        = "terraform2"
  platform_id = "standard-v2"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8vmcue7aajpmeo39kk"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    #user-data = "${file("C:\\Users\\iec_000\\yandex-cloud-terraform\\cloud-config.txt")}" - for Windows OS
    user-data = "${file("/Users/ivanov1/Projects/yc_terraform_k8s/cloud-config.txt")}" #for MacOS of Linux
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-b"
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