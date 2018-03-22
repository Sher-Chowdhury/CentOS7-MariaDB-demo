# -*- mode: ruby -*-
# vi: set ft=ruby :


# http://stackoverflow.com/questions/19492738/demand-a-vagrant-plugin-within-the-vagrantfile
# not using 'vagrant-vbguest' vagrant plugin because now using bento images which has vbguestadditions preinstalled.
required_plugins = %w( vagrant-hosts vagrant-share vagrant-vbox-snapshot vagrant-host-shell vagrant-triggers vagrant-reload )
plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
if not plugins_to_install.empty?
  puts "Installing plugins: #{plugins_to_install.join(' ')}"
  if system "vagrant plugin install #{plugins_to_install.join(' ')}"
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort "Installation of one or more plugins has failed. Aborting."
  end
end



Vagrant.configure(2) do |config|
  config.vm.define "mariadb_server" do |mariadb_server|
    mariadb_server.vm.box = "bento/centos-7.4"
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
    mariadb_client.vm.box = "bento/centos-7.4"
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
    provisioner.add_host '10.2.5.11', ['mariadb-client.example.com']
  end

end