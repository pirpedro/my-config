# -*- mode: ruby -*-
# vi: set ft=ruby :
ENV["LC_ALL"] = "en_US.UTF-8"

Vagrant.configure("2") do |config|
  config.vm.provision :shell,
    inline:<<SCRIPT
      my_conf_dir=/usr/local/my-config
      mkdir -p /usr/local/bin
      mkdir -p $my_conf_dir/
      ln -sfF /vagrant/.version $my_conf_dir/
      ln -sfF /vagrant/bin $my_conf_dir/
      ln -sfF /vagrant/ext $my_conf_dir/
      ln -sfF /vagrant/ubuntu-packages-available $my_conf_dir/
      ln -sfF /vagrant/mac-packages-available $my_conf_dir/
      ln -sfF /vagrant/test $my_conf_dir/
      mkdir -p $my_conf_dir/packages-enabled
      ln -sfF $my_conf_dir/bin/my /usr/local/bin/my
      chmod +x /usr/local/bin/my
      chown -R vagrant $my_conf_dir
SCRIPT

  config.vm.provision "auto-completion",
    type: "shell",
    inline:<<SCRIPT
      sudo cp /vagrant/contrib/completion/my.bash /etc/bash_completion.d/my
SCRIPT

  config.vm.provision "available-packages",
    type: "shell",
    inline:<<SCRIPT
      cd /usr/local/my-config
      ln -sfF ubuntu-packages-available packages-available
SCRIPT

  config.vm.provision "bats-installation",
    type: "shell",
    inline:<<SCRIPT
      sudo add-apt-repository ppa:duggan/bats --yes
      sudo apt-get update -qq
      sudo apt-get install -qq bats

SCRIPT

  config.vm.define "ubuntu" do |ubuntu|
    ubuntu.vm.box = "bento/ubuntu-16.04"
    ubuntu.vm.hostname = "peterparker"
    ubuntu.vm.provider :virtualbox do |provider|
      provider.name = "my-config-ubuntu"
    end
  end

  config.vm.define "osx" do |osx|
    osx.vm.box = "jhcook/osx-yosemite-10.10"
    osx.vm.hostname = "stevejobs"
    osx.vm.provider :virtualbox do |provider|
      provider.name = "my-config-osx"
      provider.customize ["modifyvm", :id, "--audio", "none", "--usb", "on", "--usbehci", "off"]
    end
    osx.vm.provision "available-packages",
      type:"shell",
      preserve_order:true,
      inline:<<SCRIPT
        cd /usr/local/my-config
        ln -sfF mac-packages-available packages-available
SCRIPT
    osx.vm.provision "bats-installation",
      type:"shell",
      preserve_order:true,
      inline:<<SCRIPT
        cd /tmp
        git clone https://github.com/sstephenson/bats.git
        cd bats
        chmod +x install.sh
        ./install.sh /usr/local
SCRIPT
  end
end
