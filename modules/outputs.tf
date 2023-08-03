#output "internal_ip_address_vm" {
#  value = yandex_compute_instance.vm.network_interface.0.ip_address
#}

#output "external_ip_address_vm" {
#  value = yandex_compute_instance.vm.network_interface.0.nat_ip_address
#}

output "external_ip_address_srv" {
  value = yandex_compute_instance.srv[*].network_interface.0.nat_ip_address
}

output "external_ip_address_master" {
  value = yandex_compute_instance.master[*].network_interface.0.nat_ip_address
}

output "external_ip_address_app" {
  value = yandex_compute_instance.app[*].network_interface.0.nat_ip_address
}