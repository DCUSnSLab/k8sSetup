#!/usr/bin/env bash

# install packages 
yum install epel-release -y
yum install vim-enhanced -y
yum install git -y

# install docker 
yum install yum-utils -y
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker -y && systemctl enable --now docker

# install kubernetes cluster 
yum install kubectl-1.18.4 kubelet-1.18.4 kubeadm-1.18.4 -y
systemctl enable --now kubelet

# git clone _Book_k8sInfra.git 
#if [ $2 = 'Main' ]; then
#  git clone https://github.com/sysnet4admin/_Book_k8sInfra.git
#  mv /home/vagrant/_Book_k8sInfra $HOME
#  find $HOME/_Book_k8sInfra/ -regex ".*\.\(sh\)" -exec chmod 700 {} \;
#fi
