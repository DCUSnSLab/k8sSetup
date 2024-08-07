echo "System Update..."
#system update
yum -y install epel-release
yum -y update

echo "SELINUX disable ..."
#SELINUX disable
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config

#SWAP Disable
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo systemctl mask swap.target

echo "Network Setup ....."
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

# RHEL/CentOS 7 have reported traffic issues being routed incorrectly due to iptables bypassed
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo modprobe br_netfilter
sudo modprobe overlay
sudo sysctl --system

echo "Firewall Setup......"
#Enable Firewall
firewall-cmd --permanent --zone=public --add-port=6443/tcp
firewall-cmd --permanent --zone=public --add-port=2379-2380/tcp
firewall-cmd --permanent --zone=public --add-port=10250/tcp
firewall-cmd --permanent --zone=public --add-port=10251/tcp
firewall-cmd --permanent --zone=public --add-port=10252/tcp
firewall-cmd --permanent --zone=public --add-port=10255/tcp
firewall-cmd --permanent --zone=public --add-port=30000-32767/tcp
firewall-cmd --permanent --zone=public --add-port=179/tcp
firewall-cmd --permanent --zone=public --add-port=80/tcp
firewall-cmd --permanent --zone=public --add-port=443/tcp
firewall-cmd --permanent --zone=public --add-port=4443/tcp
firewall-cmd --permanent --zone=public --add-port=7946/tcp
firewall-cmd --permanent --zone=public --add-port=4433/tcp
firewall-cmd --permanent --zone=public --add-port=9100/tcp
firewall-cmd --permanent --zone=public --add-port=7472/tcp
firewall-cmd --permanent --zone=public --add-port=8080/tcp
firewall-cmd --permanent --zone=public --add-port=8181/tcp
firewall-cmd --permanent --zone=public --add-port=4789/tcp
firewall-cmd --permanent --zone=public --add-port=5473/tcp
firewall-cmd --permanent --zone=public --add-port=9153/tcp
firewall-cmd --permanent --zone=public --add-port=8022/tcp
firewall-cmd --permanent --zone=public --add-port=9090/tcp
firewall-cmd --permanent --zone=public --add-port=7472/tcp
firewall-cmd --permanent --zone=public --add-port=6379/tcp
firewall-cmd --reload
sudo systemctl stop firewalld
sudo systemctl disable firewalld

echo "hosts setup...."
# local small dns & vagrant cannot parse and delivery shell code.
echo "203.250.32.103 k8s-lb1" >> /etc/hosts
echo "203.250.34.161 k8s-lb2 " >> /etc/hosts
echo "203.250.35.87 m1-k8s" >> /etc/hosts
echo "203.250.34.157 m2-k8s" >> /etc/hosts
echo "203.250.35.27 m3-k8s" >> /etc/hosts
echo "203.250.32.220 n1-k8s" >> /etc/hosts
echo "203.250.33.103 n2-k8s" >> /etc/hosts
echo "203.250.32.219 n3-k8s" >> /etc/hosts
echo "203.250.33.87 n4-k8s" >> /etc/hosts
echo "203.250.35.243 d1-k8s" >> /etc/hosts
echo "203.250.33.67 d2-k8s" >> /etc/hosts
echo "203.250.33.90 harbor.cu.ac.kr" >> /etc/hosts


#inser kubenetes repo
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF

#install kube
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet

#install containerd
yum install yum-utils -y
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io -y

#install NFS
yum install -y nfs-utils

#start containerd
systemctl enable --now containerd
systemctl start containerd
systemctl enable --now kubelet
systemctl start kubelet
systemctl enable --now docker
systemctl start docker

#docker.sock 권한 변경 및 시작프로그램 등록
sudo chmod 666 /var/run/docker.sock
echo "sudo chmod 666 /var/run/docker.sock" | sudo tee -a /etc/rc.d/rc.local > /dev/null
