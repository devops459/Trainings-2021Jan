#! /bin/bash
### Create kubeadm user and grant root access

user_id='kubadm'
groupadd -g 9999 ${user_id}
useradd -g 9999 -u 1111 ${user_id} -p '$1$EDFicvJi$v132S2KpBhhRTcxxP5PzD.'
cp /etc/sudoers.d/90-cloud-init-users /etc/sudoers.d/${user_id}
sed -i "s/centos/${user_id}/g" /etc/sudoers.d/${user_id}
sed -i 's#PasswordAuthentication no#PasswordAuthentication yes#g' /etc/ssh/sshd_config
systemctl restart sshd

#### Install and Configure Docker
yum install -y yum-utils device-mapper-persistent-data lvm2

if [ ! $? -eq 0 ]
then
	echo "Installtion of YUM Utilis is failed"
	exit 100
fi

sudo yum-config-manager --add-repo   https://download.docker.com/linux/centos/docker-ce.repo
sudo yum update -y
sudo yum install -y docker-ce-18.09.0 docker-ce-cli-18.09.0 containerd.io-1.2.6
sudo mkdir /etc/docker

sudo cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

sudo mkdir -p /etc/systemd/system/docker.service.d
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl enable docker

### Install pre requisits of Kubeernetes and rpm'#!/bin/sh

sudo modprobe br_netfilter

sudo cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system

sudo cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
sudo yum install -y kubeadm-1.18.10-0 kubelet-1.18.10-0  kubectl-1.18.10-0 --disableexcludes=kubernetes
sudo systemctl enable --now kubelet
