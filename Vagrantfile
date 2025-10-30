Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.hostname = "k3s-lab"
  config.vm.network "private_network", ip: "192.168.56.10"

  config.vm.provider "virtualbox" do |vb|
    vb.name = "k3s-lab"
    vb.memory = 8048
    vb.cpus = 4
  end

  config.vm.provision "shell", path: "scripts/install_base.sh"
  config.vm.provision "shell", path: "scripts/setup_registry.sh"
  config.vm.provision "shell", path: "scripts/install_k3s.sh"
end
