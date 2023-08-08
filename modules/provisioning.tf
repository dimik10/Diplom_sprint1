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
# запуск установки кластера k8s
  provisioner "remote-exec" {
    inline = [
    "cd kuberspray/",
    "ansible-playbook -i inventory/mycluster/inventory.ini --become -u ubuntu --private-key /home/ubuntu/.ssh/id_rsa cluster.yml",
    ]
  }
}




