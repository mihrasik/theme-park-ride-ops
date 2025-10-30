# Vagrantfile  (replace the whole file with this – keeps your old containers for reference)

VAGRANTFILE_API_VERSION = "2"
BOX = "ubuntu/jammy64"                 # 22.04 LTS, works on Intel/AMD and Apple Silicon (via Parallels/VirtualBox)

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'   # or 'parallels' on M1/M2

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = BOX
  config.vm.hostname = "k3s-host"

  # 2 CPU, 4 GB RAM – enough for k3s + 3 app pods + MariaDB
  config.vm.provider "virtualbox" do |vb|
    # vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.cpus = 4
    vb.memory = 12096
    vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
  end

  # Forward the k3s API and the Ingress
  config.vm.network "forwarded_port", guest: 6443, host: 6443   # k3s API
  config.vm.network "forwarded_port", guest: 80,   host: 8088   # Nginx Ingress

  # Private network so the host can talk to the k3s node (same subnet you used before)
  config.vm.network "private_network", ip: "192.168.56.100"

  # -------------------------------------------------
  # 1. Provision Docker, k3s, Terraform, Helm
  # -------------------------------------------------
  config.vm.provision "shell", path: "vagrant/provision.sh", privileged: true

  # -------------------------------------------------
  # 2. Build **local** Docker images (no push)
  # -------------------------------------------------
  config.vm.provision "shell", inline: <<-SHELL
    set -e
    cd /vagrant

    # Detect arch (same logic you already have)
    ARCH=$(dpkg --print-architecture)   # amd64 or arm64
    DOCKERFILE="containers/app/Dockerfile.${ARCH}"

    echo "Building app image for $ARCH ..."
    docker build -f "$DOCKERFILE" -t local/app:latest .

    echo "Building db image ..."
    docker build -t local/mariadb:latest ./containers/db

    echo "Building lb image ..."
    docker build -t local/nginx-lb:latest ./containers/lb

    # Save images to a shared folder so Terraform can load them into k3s
    mkdir -p /vagrant/docker-images
    docker save local/app:latest      -o /vagrant/docker-images/app.tar
    docker save local/mariadb:latest  -o /vagrant/docker-images/mariadb.tar
    docker save local/nginx-lb:latest -o /vagrant/docker-images/lb.tar
  SHELL
   # Add the user to the k3s group
  # config.vm.provision "shell", inline: <<-SHELL
  #   set -e
  #   usermod -aG k3s $USER
  # SHELL
end