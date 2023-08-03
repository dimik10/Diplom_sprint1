resource "null_resource" "k8s-srv" {
  count = var.srv
  depends_on = [yandex_compute_instance.srv]
  connection {
    user        = var.ssh_credentials.user
    private_key = file(var.ssh_credentials.private_key)
    host        = yandex_compute_instance.srv[count.index].network_interface.0.nat_ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ~/.ssh",
      "echo create dir ssh COMPLETED"
    ]
  }

#  provisioner "file" {
#    source      = "inventory"
#    destination = "inventory"
# }


  provisioner "file" {
    source      = "~/.ssh/yandex1"
    destination = ".ssh/id_rsa"
  }

#  provisioner "file" {
#    source      = "ansible/"
#    destination = "ansible"
#  }

  provisioner "remote-exec" {
    inline = [
#      "sudo apt install -y ansible > /dev/null",
      "chmod 0600 .ssh/id_rsa",
#      "ansible-playbook -i inventory ansible/install.yml -u ubuntu",
#      "echo COMPLETED chmod ssh"
    ]
  }

  provisioner "local-exec" {
    command = "./terraform-inventory -inventory . > inventory_ansible"
  }

  provisioner "local-exec" {
    command = "./inv.sh > inventory.ini"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory_ansible --limit=module_k8s_cluster_srv ansible/install.yml -u ubuntu"
  }

  provisioner "file" {
    source      = "inventory/mycluster"
    destination = "kuberspray/inventory"
  }
  provisioner "file" {
    source      = "inventory.ini"
    destination = "kuberspray/inventory/mycluster/inventory.ini"
  }
}

#resource "null_resource" "docker-swarm-manager-join" {
#  count = var.managers
#  depends_on = [yandex_compute_instance.vm1, null_resource.docker-swarm-manager]
#  connection {
#    user        = var.ssh_credentials.user
#    private_key = file(var.ssh_credentials.private_key)
#    host        = yandex_compute_instance.vm1[count.index].network_interface.0.nat_ip_address
#  }
#
#  provisioner "local-exec" {
#    command = "TOKEN=$(ssh -i ${var.ssh_credentials.private_key} -o StrictHostKeyChecking=no ${var.ssh_credentials.user}@${yandex_compute_instance.vm1[count.index].network_interface.0.nat_ip_address} sudo docker swarm join-token -q worker); echo \"#!/usr/bin/env bash\nsudo docker swarm join --token $TOKEN ${yandex_compute_instance.vm1[count.index].network_interface.0.nat_ip_address}:2377\nexit 0\" >| join.sh"
#  }
#}

#resource "null_resource" "docker-swarm-worker" {
#  count = var.workers
#  depends_on = [yandex_compute_instance.vm2, null_resource.docker-swarm-manager-join]
#  connection {
#    user        = var.ssh_credentials.user
#    private_key = file(var.ssh_credentials.private_key)
#    host        = yandex_compute_instance.vm2[count.index].network_interface.0.nat_ip_address
# }
#
#  provisioner "file" {
#    source      = "join.sh"
#    destination = "join.sh"
#  }
#
#  provisioner "remote-exec" {
#    inline = [
#      "sudo apt install -y docker docker-compose > /dev/null",
#      "sudo chmod +x join.sh",
#      "sudo ./join.sh"
#    ]
#  }
#}

#resource "null_resource" "docker-swarm-manager-start" {
#  depends_on = [yandex_compute_instance.vm1, null_resource.docker-swarm-manager-join]
#  connection {
#    user        = var.ssh_credentials.user
#    private_key = file(var.ssh_credentials.private_key)
#    host        = yandex_compute_instance.vm1[0].network_interface.0.nat_ip_address
#  }
#
#  provisioner "remote-exec" {
#    inline = [
#        "sudo docker stack deploy --compose-file docker-compose.yml noski-shop-swarm"
#    ]
#  }
#
#  provisioner "local-exec" {
#    command = "git clone https://github.com/kubernetes-sigs/kubespray.git"
#  }
#}