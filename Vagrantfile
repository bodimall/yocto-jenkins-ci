# -*- mode: ruby -*-
# vi: set ft=ruby :

vm_name = "modern-jenkins"

Vagrant.configure("2") do |config|
  config.vm.define "virtualbox-ubuntu2204" do |virtualbox_ubuntu2204|
      virtualbox_ubuntu2204.vm.box = "generic/ubuntu2204"
      virtualbox_ubuntu2204.vm.box_version = "4.1.0"

      config.vm.provider "virtualbox" do |vb|
          vb.name = vm_name
          vb.memory = "4096"
          vb.cpus = 4
          vb.customize ["modifyvm", :id, "--vram", "128"]
          vb.customize ["modifyvm", :id, "--spec-ctrl", "on"]
      end
  end

  config.vm.define "libvirt-ubuntu2204" do |libvirt_ubuntu2204|
      libvirt_ubuntu2204.vm.box = "generic/ubuntu2204"
      libvirt_ubuntu2204.vm.box_version = "4.1.0"

      config.vm.provider "libvirt" do |libvirt|
          libvirt.memory = "4096"
          libvirt.cpus = 4
      end
  end

  config.vm.define "virtualbox-bullseye" do |virtualbox_bullseye|
      virtualbox_bullseye.vm.box = "debian/bullseye64"
      virtualbox_bullseye.vm.box_version = "11.20220718.1"

      config.vm.provider "virtualbox" do |vb|
          vb.name = vm_name
          vb.memory = "4096"
          vb.cpus = 4
          vb.customize ["modifyvm", :id, "--vram", "128"]
          vb.customize ["modifyvm", :id, "--spec-ctrl", "on"]
      end
  end

  config.vm.define "libvirt-bullseye" do |libvirt_bullseye|
      libvirt_bullseye.vm.box = "debian/bullseye64"
      libvirt_bullseye.vm.box_version = "11.20220718.1"

      config.vm.provider "libvirt" do |libvirt|
          libvirt.memory = "4096"
          libvirt.cpus = 4
      end
  end

  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true

  config.vm.hostname = vm_name

  config.vm.network "private_network", type: "dhcp"
  config.vm.network "forwarded_port", guest: 80, host: 80
  config.vm.network "forwarded_port", guest: 443, host: 443

  config.vm.synced_folder ".", "/vagrant",
      type: "rsync"
  config.vm.provision "shell",
      inline: "/vagrant/vagrant-ansible.sh",
      privileged: false
end
