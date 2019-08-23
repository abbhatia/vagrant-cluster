varAnsibleController = "ansible-controller"
varPrefixNodes = "dell"

varRamAnsible=4096
varRamNode=6144

varDomain = "ab.internal"
varRepository = "D:/GoogleDrive/mydocs/udemy_vagrant_cloudera/1_create_base_boxes/REPOSITORY"

nodes = [
	{ :host => "#{varAnsibleController}",  :ip => "192.168.22.10", :box => "bento/centos-7.6", :ram => varRamAnsible, :cpu => 2, :gui => false },
	{ :host => "#{varPrefixNodes}-node-1",  :ip => "192.168.22.12", :box => "bento/centos-7.6", :ram => varRamNode, :cpu => 2, :gui => false },
	{ :host => "#{varPrefixNodes}-node-2",  :ip => "192.168.22.13", :box => "bento/centos-7.6", :ram => varRamNode, :cpu => 2, :gui => false },
	{ :host => "#{varPrefixNodes}-node-3",  :ip => "192.168.22.14", :box => "bento/centos-7.6", :ram => varRamNode, :cpu => 2, :gui => false },
]

varHostEntries = ""
nodes.each do |node|
	varHostEntries << "#{node[:ip]} #{node[:host]}.#{varDomain} #{node[:host]}\n"
end

puts varHostEntries

$etchosts = <<SCRIPT
#!/bin/bash
cat > /etc/hosts <<EOF
127.0.0.1       localhost
192.168.22.1      host.#{varDomain} host
#{varHostEntries}
EOF
SCRIPT


$nodescript = <<SCRIPT
cat /vagrant/certificates/ansible_lab.pub >> /home/vagrant/.ssh/authorized_keys
SCRIPT

$ansiblescript = <<SCRIPT
sudo yum install ansible git -y
mkdir /home/vagrant/workspace
cd /home/vagrant/workspace
git clone https://github.com/confluentinc/cp-ansible.git
sudo cp -r /vagrant/certificates/ansible_lab /home/vagrant/.ssh/id_rsa
sudo chmod 400  /home/vagrant/.ssh/id_rsa
sudo chown vagrant:vagrant /home/vagrant/.ssh/id_rsa
SCRIPT

Vagrant.configure("2") do |config|

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = false
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  nodes.each do |node|
	config.vm.define node[:host] do |pocd_config|
	
		pocd_config.ssh.username = "vagrant"
		pocd_config.ssh.password = "vagrant"
	
		pocd_config.vm.box = node[:box]
		pocd_config.vm.hostname = "#{node[:host]}.#{varDomain}"
		pocd_config.vm.network "public_network", bridge: "p3p1", ip: node[:ip], :netmask => "255.255.255.0"
		
		pocd_config.hostmanager.aliases = "#{node[:host]}"
		
		pocd_config.vm.provider :virtualbox do |v|
			v.name = node[:host].to_s
			v.gui = node[:gui]
			
			v.customize ["modifyvm", :id, "--memory", node[:ram].to_s]
			v.customize ["modifyvm", :id, "--cpus", node[:cpu].to_s]			
		end

		pocd_config.vm.provision "shell", inline: $etchosts

		
		pocd_config.vm.provision :shell, :path => "os-tuning/provision_for_print_os.sh"
		pocd_config.vm.provision :shell, :path => "os-tuning/provision_for_os_settings.sh"
		pocd_config.vm.provision :shell, :path => "os-tuning/provision_for_os.sh"
		pocd_config.vm.provision :shell, :path => "os-tuning/provision_for_print_os.sh"
				
		if node[:host] == varAnsibleController
			pocd_config.vm.provision "shell", inline:  $ansiblescript, privileged: false
		else
			pocd_config.vm.provision "shell", inline:  $nodescript
		end
	end
  end	
end
