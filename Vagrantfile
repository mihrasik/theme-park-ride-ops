Vagrant.configure("2") do |config|
  config.vm.define "app1" do |app1|
    app1.vm.hostname = "app1"
    app1.vm.provider "docker" do |d|
      d.name = "openjdk12-ssh"
      d.build_dir = "."
      d.remains_running = true
      
      d.has_ssh = true
      d.cmd = ["/usr/sbin/sshd", "-D"]
      d.ports = ["5000:5000", "2201:22", "8080:8080"]
    end

    # SSH setup to use vagrant's insecure key
    app1.ssh.username = "vagrant"
    app1.ssh.private_key_path = File.expand_path("~/.vagrant.d/insecure_private_key")
    app1.ssh.insert_key = false
    app1.vm.network "private_network", ip: "192.168.10.10", netmask: 24
    app1.vm.network "forwarded_port", guest: 5000, host: 5001
  end
  config.vm.define "db" do |db|
    db.vm.provider "docker" do |d|
        # d.image = "mariadb:latest"
        d.build_dir = "./containers/db"
        d.name = "mariadb"
        d.ports = ["3306:3306", "2202:22"]
        d.env = {
            MYSQL_ROOT_PASSWORD: "root",
            MYSQL_USER: "root",
            MYSQL_PASS: "root"
        }
    end
    # SSH setup to use vagrant's insecure key
    db.ssh.username = "vagrant"
    db.ssh.private_key_path = File.expand_path("~/.vagrant.d/insecure_private_key")
    db.ssh.insert_key = false
    db.vm.network "private_network", ip: "192.168.10.22", netmask: 24
  end

end

