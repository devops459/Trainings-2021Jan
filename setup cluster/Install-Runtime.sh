#### Install and Configure Docker 

yum install -y yum-utils device-mapper-persistent-data lvm2

if [ ! $? -eq 0 ]
then
	echo "Installtion of YUM Utilis is failed" 
	exit 100
fi

yum-config-manager --add-repo   https://download.docker.com/linux/centos/docker-ce.repo
yum update -y
yum install -y docker-ce-18.09.0 docker-ce-cli-18.09.0 containerd.io-1.2.6
mkdir /etc/docker

cat <<EOF | sudo tee /etc/docker/daemon.json
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

mkdir -p /etc/systemd/system/docker.service.d
systemctl daemon-reload
systemctl restart docker
systemctl enable docker



