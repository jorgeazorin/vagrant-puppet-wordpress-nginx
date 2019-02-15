# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "matt-zivtech/ubuntu-18.04-server-puppet-5"

  config.vm.network "private_network", ip:"192.168.33.20"
  config.vm.network "forwarded_port", guest: 80, host: 8080
  
  config.vm.provider"virtualbox"do |vb|
    vb.memory ="1024"
  end

  config.vm.provision :"puppet" do |puppet|
    puppet.module_path = "modules"
    puppet.manifests_path = "manifests"
    puppet.manifest_file = "default.pp"
  end


end
