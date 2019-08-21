 
pocd_nodes = [
	{ :host => "cm571-template", :ip => "192.168.0.76", :box => "bento/centos-7.6", :ram => 1024, :cpu => 1, :gui => false },
	#{ :host => "cm571-template2", :ip => "10.10.45.10", :box => "bento/centos-7.6", :ram => 2048, :cpu => 2, :gui => false },
]


varDomain = "poc-d.internal"
varRepository = "repository/"

Vagrant.configure("2") do |config|

    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.manage_guest = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true
 
	pocd_nodes.each do |pocd_node|

		config.vm.define pocd_node[:host] do |pocd_config|

			pocd_config.vm.box = pocd_node[:box]
			#pocd_config.vm.box_version = "1905.1"
			
			pocd_config.vm.network "public_network", bridge: "enp2s0f1", ip: pocd_node[:ip], :netmask => "255.255.255.0"
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

		    pocd_config.vm.provision :shell, :path => "java/provision_for_java.sh"

		end
	end		
end
