terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.61.0"
    }

  }
}


provider "yandex" {
  token     = var.yandex_cloud_token
  cloud_id  = var.yandex_cloud_id
  folder_id = var.yandex_folder_id
  zone      = var.zone[0]
}


resource "yandex_vpc_network" "network" {
  name = "network_kuber"
}

#Создание подсети
resource "yandex_vpc_subnet" "subnet_kuber" {
  name           = "subnet_kuber"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.12.0/24"]
}

module "k8s_cluster" {
  source                = "./modules"
  instance_family_image = "ubuntu-2004-lts"
  vpc_subnet_id         = yandex_vpc_subnet.subnet_kuber.id
#  managers      = 1
#  workers       = 2
}
