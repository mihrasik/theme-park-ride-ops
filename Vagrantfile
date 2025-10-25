Vagrant.configure("2") do |config|
  config.vm.provider "docker" do |d|
    d.name = "openjdk12-ssh"
    d.build_dir = "."
    d.remains_running = true
    d.has_ssh = true
    d.cmd = ["/usr/sbin/sshd", "-D"]
    d.ports = ["5000:5000", "2222:22", "8080:8080"]
  end

  # SSH setup to use vagrant's insecure key
  config.ssh.username = "vagrant"
  config.ssh.private_key_path = File.expand_path("~/.vagrant.d/insecure_private_key")
  config.ssh.insert_key = false
end
