terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.61.0"
    }
  }
}
data "yandex_compute_image" "my_image" {
  family = var.instance_family_image
}


resource "yandex_compute_instance" "srv" {
  name = "k8s-srv-${count.index}"
  count    = var.srv
  hostname = "srv-${count.index}"
  
  resources {
    cores         = 4
    memory        = 8
    core_fraction = 100 # Выделение загрузки CPU. Это дешевле. (для проверки)
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.id
      size = "${var.instance_root_disk}"
    }
  }

  network_interface {
    subnet_id = var.vpc_subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "${var.ssh_credentials.user}:${file(var.ssh_credentials.pub_key)}"
  }

  scheduling_policy {
    preemptible = false # ВМ прирываема. Это дешевле. (для проверки). Не прод.
  }
}

resource "yandex_compute_instance" "master" {
  name = "k8s-master${count.index}"
  count    = var.master
  hostname = "k8s-master-${count.index}"
  
  resources {
    cores         = 4
    memory        = 8
    core_fraction = 100 # Выделение загрузки CPU. Это дешевле. (для проверки)
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.id
      size = "${var.instance_root_disk}"
    }
  }

  network_interface {
    subnet_id = var.vpc_subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "${var.ssh_credentials.user}:${file(var.ssh_credentials.pub_key)}"
  }

  scheduling_policy {
    preemptible = false # ВМ прирываема. Это дешевле. (для проверки). Не прод.
  }
}

resource "yandex_compute_instance" "app" {
  name = "k8s-app${count.index}"
  count    = var.app
  hostname = "k8s-app-${count.index}"
  
  resources {
    cores         = 4
    memory        = 8
    core_fraction = 100 # Выделение загрузки CPU. Это дешевле. (для проверки)
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.id
      size = "${var.instance_root_disk}"
    }
  }

  network_interface {
    subnet_id = var.vpc_subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "${var.ssh_credentials.user}:${file(var.ssh_credentials.pub_key)}"
  }

  scheduling_policy {
    preemptible = false # ВМ прирываема. Это дешевле. (для проверки). Не прод.
  }
}

