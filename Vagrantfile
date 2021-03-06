# -*- mode: ruby -*-
# vi: set ft=ruby :


# https://github.com/hashicorp/vagrant/issues/1874#issuecomment-165904024
# not using 'vagrant-vbguest' vagrant plugin because now using bento images which has vbguestadditions preinstalled.
def ensure_plugins(plugins)
  logger = Vagrant::UI::Colored.new
  result = false
  plugins.each do |p|
    pm = Vagrant::Plugin::Manager.new(
      Vagrant::Plugin::Manager.user_plugins_file
    )
    plugin_hash = pm.installed_plugins
    next if plugin_hash.has_key?(p)
    result = true
    logger.warn("Installing plugin #{p}")
    pm.install_plugin(p)
  end
  if result
    logger.warn('Re-run vagrant up now that plugins are installed')
    exit
  end
end

required_plugins = ['vagrant-hosts', 'vagrant-share', 'vagrant-vbox-snapshot', 'vagrant-host-shell', 'vagrant-reload']
ensure_plugins required_plugins



Vagrant.configure(2) do |config|
  config.vm.define "mariadb_server" do |mariadb_server|
    mariadb_server.vm.box = "bento/centos-7.5"
    mariadb_server.vm.hostname = "mariadb-server.example.com"
    # https://www.vagrantup.com/docs/virtualbox/networking.html
    mariadb_server.vm.network "private_network", ip: "10.2.5.10", :netmask => "255.255.255.0", virtualbox__intnet: "intnet2"

    mariadb_server.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.memory = "1024"
      vb.cpus = 2
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.name = "centos7_mariadb_server"
    end

    mariadb_server.vm.provision "shell", path: "scripts/install-rpms.sh", privileged: true
    mariadb_server.vm.provision "shell", path: "scripts/setup_mariadb_server.sh", privileged: true
  end


  config.vm.define "mariadb_client" do |mariadb_client|
    mariadb_client.vm.box = "bento/centos-7.5"
    mariadb_client.vm.hostname = "mariadb-client.example.com"
    mariadb_client.vm.network "private_network", ip: "10.2.5.12", :netmask => "255.255.255.0", virtualbox__intnet: "intnet2"

    mariadb_client.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.memory = "1024"
      vb.cpus = 2
      vb.name = "centos7_mariadb_client"
    end

    mariadb_client.vm.provision "shell", path: "scripts/install-rpms.sh", privileged: true
    mariadb_client.vm.provision "shell", path: "scripts/setup_mariadb_client.sh", privileged: true
  end

  config.vm.provision :hosts do |provisioner|
    provisioner.add_host '10.2.5.10', ['mariadb-server.example.com']
    provisioner.add_host '10.2.5.12', ['mariadb-client.example.com']
  end

end