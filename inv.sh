#!/bin/bash

set -e

w1=$(cat terraform.tfstate | grep -e '"nat_ip_address":' -e '"hostname":'| awk '{print $2}' | tr -d ',' | tr -d '"'  | grep -A 1 "k8s-master-" | tail -1)
w2=$(cat terraform.tfstate | grep -e '"ip_address":' -e '"hostname":'| awk '{print $2}' | tr -d ',' | tr -d '"'  | grep -A 1 "k8s-master-" | tail -1)
a1=$(cat terraform.tfstate | grep -e '"nat_ip_address":' -e '"hostname":'| awk '{print $2}' | tr -d ',' | tr -d '"'  | grep -A 1 "k8s-app-" | tail -1)
a2=$(cat terraform.tfstate | grep -e '"ip_address":' -e '"hostname":'| awk '{print $2}' | tr -d ',' | tr -d '"'  | grep -A 1 "k8s-app-" | tail -1)
printf "[all]\n"

for num in 1 
do
printf "k8s-master-$num   ansible_host=$w1"
printf "   ip= $w2"
printf "   etcd_member_name=etcd-$num\n"
done

for num in 1
do
printf "k8s-app-$num   ansible_host=$a1"
printf "   ip=$a2"
printf "\n"
done

printf "\n[all:vars]\n"
printf "ansible_user=ubuntu\n"
printf "supplementary_addresses_in_ssl_keys='$w1 $w2"
printf "'\n\n"

cat << EOF
[kube-master]
k8s-master-1

[etcd]
k8s-master-1

[kube-node]
k8s-app-1

[kube-worker]
k8s-master-1

[kube-ingress]

[k8s-cluster:children]
k8s-master-1
k8s-app-1
EOF