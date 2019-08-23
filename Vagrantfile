 
pocd_nodes = [
	{ :host => "dell-home-1", :ip => "192.168.0.71", :box => "bento/centos-7.6", :ram => 4096, :cpu => 2, :gui => false },
        { :host => "dell-home-2", :ip => "192.168.0.72", :box => "bento/centos-7.6", :ram => 4096, :cpu => 2, :gui => false },
        { :host => "dell-home-3", :ip => "192.168.0.73", :box => "bento/centos-7.6", :ram => 4096, :cpu => 2, :gui => false },
        { :host => "dell-home-4", :ip => "192.168.0.74", :box => "bento/centos-7.6", :ram => 4096, :cpu => 2, :gui => false },
]


varDomain = "poc-d.internal"
varRepository = "repository/"

varHostEntries = ""
pocd_nodes.each do |pocd_node|
	varHostEntries << "#{pocd_node[:ip]} #{pocd_node[:host]}.#{varDomain} #{pocd_node[:host]}\n"
end

puts varHostEntries
#global script
$global = <<SCRIPT

#check for private key for vm-vm comm
[ -f /vagrant/id_rsa ] || {
  ssh-keygen -t rsa -f /vagrant/id_rsa -q -N ''
}

#deploy key
[ -f /home/vagrant/.ssh/id_rsa ] || {
    cp /vagrant/id_rsa /home/vagrant/.ssh/id_rsa
    chmod 0600 /home/vagrant/.ssh/id_rsa
}

#allow ssh passwordless
grep 'vagrant@dell' ~/.ssh/authorized_keys &>/dev/null || {
  cat /vagrant/id_rsa.pub >> ~/.ssh/authorized_keys
  chmod 0600 ~/.ssh/authorized_keys
}

#exclude dell* from host checking
cat > ~/.ssh/config <<EOF
Host dell*
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null
EOF

#end script
SCRIPT

prefix="dell"

$etchosts = <<SCRIPT
#!/bin/bash
cat > /etc/hosts <<EOF
127.0.0.1       localhost
10.10.47.1      host.#{varDomain} host
#{varHostEntries}
EOF
SCRIPT

Vagrant.configure("2") do |config|

    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.manage_guest = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true
 
	pocd_nodes.each do |pocd_node|

		config.vm.define pocd_node[:host] do |pocd_config|

			pocd_config.vm.box = pocd_node[:box]
			
			pocd_config.vm.network "public_network", bridge: "p3p1", ip: pocd_node[:ip], :netmask => "255.255.255.0"
			pocd_config.vm.hostname = "#{pocd_node[:host]}.#{varDomain}"
			# pocd_config.vm.hostname = pocd_node[:host] + "." + varDomain

		    pocd_config.hostmanager.aliases = "#{pocd_node[:host]}"

			pocd_config.vm.provider :virtualbox do |v|
				v.name = pocd_node[:host].to_s
				v.gui = pocd_node[:gui]

				v.customize ["modifyvm", :id, "--memory", pocd_node[:ram].to_s ]
				v.customize ["modifyvm", :id, "--cpus", pocd_node[:cpu].to_s ]
			end

			pocd_config.vm.synced_folder varRepository, "/repository", 
				id: "repository",
				owner: "vagrant",
				group: "vagrant"

		    #pocd_config.vm.provision :shell, :path => "java/provision_for_java.sh"
			pocd_config.vm.provision "shell", privileged: false, inline: $global

			pocd_config.vm.provision :shell, :inline => $etchosts
		
			pocd_config.vm.provision :shell, :path => "os-tuning/provision_for_print_os.sh"
			pocd_config.vm.provision :shell, :path => "os-tuning/provision_for_os_settings.sh"
			pocd_config.vm.provision :shell, :path => "os-tuning/provision_for_os.sh"
			pocd_config.vm.provision :shell, :path => "os-tuning/provision_for_print_os.sh"
				

		end
	end		
end
