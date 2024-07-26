echo "Setup Rocky OS huge page..."
echo "vm.nr_hugepages = 4096" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

echo "Setup nvme-tcp..."
sudo modprobe nvme-tcp
echo "nvme-tcp" | sudo tee /etc/modules-load.d/nvme-tcp.conf