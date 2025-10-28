ENV['VAGRANT_DEFAULT_PROVIDER'] = 'docker' # We define the provider to use which is Docker, Start of instruction 1
app_nodes = 3
cidr_prefix = "192.168.10"

Vagrant.configure("2") do |config|
  (1..app_nodes).each do |i|
  config.vm.define "app#{i}" do |app|
    app.vm.hostname = "app#{i}"
    app.vm.provider "docker" do |d|
      d.name = "app#{i}"
      # d.build_dir = "./containers/app"
      d.remains_running = true
      
      d.build_dir = "."  # <--- Build from project root!
      d.dockerfile = "containers/app/Dockerfile"  # <--- Specify Dockerfile location

      d.build_args = ["-t", "app"]  # <--- Tag the image with a unique name
      d.remains_running = true
      
      d.has_ssh = true
      d.cmd = ["/usr/sbin/sshd", "-D"]
      d.ports = ["#{5001 + i}:5000", "#{2201 + i}:22", "#{8081 + i}:8080"]
      d.env = {
        "DB_HOST" => "mariadb",
        "DB_PORT" => "3306",
        "DB_NAME" => "themepark",
        "DB_USER" => "app",
        "DB_PASSWORD" => "app"
      }
    end

    # SSH setup to use vagrant's insecure key
    app.ssh.username = "vagrant"
    app.ssh.private_key_path = File.expand_path("~/.vagrant.d/insecure_private_key")
    app.ssh.insert_key = false
    app.vm.network "private_network", ip: "#{cidr_prefix}.#{10 + i}", netmask: 24
    app.vm.network "forwarded_port", guest: 5000, host: "#{5001 + i}"
  end
  end
  config.vm.define "db" do |db|
    db.vm.provider "docker" do |d|
      d.build_dir = "./containers/db"
      d.name = "mariadb"
      d.ports = ["3306:3306", "2242:22"]
      d.env = {
        "MARIADB_ROOT_PASSWORD" => "root",
        "MARIADB_USER" => "app",
        "MARIADB_PASSWORD" => "app",
        "MARIADB_DATABASE" => "themepark"
      }
      d.remains_running = true
    end

    db.ssh.username = "vagrant"
    db.ssh.private_key_path = File.expand_path("~/.vagrant.d/insecure_private_key")
    db.ssh.insert_key = false
    db.vm.network "private_network", ip: "192.168.10.22"
  end
  config.vm.define "lb" do |lb| # We define a name for the instance we have to set up
       
    lb.vm.network "private_network", ip: "192.168.10.33", netmask: 24
   
    lb.vm.hostname = "lb"
    lb.vm.network "forwarded_port", guest: 80, host: 8088 # 
    lb.vm.provider "docker" do |lb_docker| # Start of instruction 3
      lb_docker.build_dir = "./containers/lb" # We define the docker image to use
      lb_docker.has_ssh = true # Possible connection in SSH
      lb_docker.privileged = true # Run the container with privileges on the underlying machine
       # Combine all Docker create args here
       # Configure CPU and memory using create_args
      lb_docker.create_args = [
        "--cpus=1",                  # Allocate 2 CPU cores
        "--memory=2048m",            # Allocate 2048 MB (2 GB) of memory
        "-v", "/sys/fs/cgroup:/sys/fs/cgroup:ro"  # Mount cgroup (required for some Docker versions)
      ]

      lb_docker.name = "lb" #We define a name for our container
    end #End of statement 3
  end #End of instruction 2
end

