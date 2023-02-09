#reset node
sudo kubeadm reset

sudo ip link delete cni0
sudo ip link delete flannel.1

#delete files
sudo rm -rf /var/lib/cni/
sudo rm -rf /var/lib/kubelet/*
sudo rm -rf /var/lib/etcd/
sudo rm -rf /run/flannel
sudo rm -rf /etc/cni/
sudo rm -rf /etc/kubernetes
sudo rm -rf ~/.kube

#delete packages
sudo yum remove kubeadm kubectl kubelet kubernetes-cni kube*
sudo yum autoremove

#install kube
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet

#install containerd
yum install yum-utils -y
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install containerd.io -y

#start containerd
systemctl enable --now containerd
systemctl start containerd

#daemon editing
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


