Vagrant.configure("2") do |config|

  # tunables
  env_prefix  = ENV['DRUPAL_VAGRANT_ENV_PREFIX'] || 'DRUPAL_VAGRANT'
  ip          = ENV["#{env_prefix}_IP"] || '10.33.36.11'
  project     = ENV["#{env_prefix}_PROJECT"] || 'drupalproject'
  # end tunables

  config.vm.box     = "promet_wheezy"
  config.vm.box_url = "https://s3.amazonaws.com/promet_debian_boxes/wheezy_virtualbox.box"
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 2048]
  end
  path = "/var/www/sites/#{project}.dev"

  config.vm.synced_folder ".", "/vagrant", :disabled => true
  config.vm.synced_folder ".", path, :nfs => true
  config.vm.hostname = "#{project}.dev"

  config.ssh.forward_agent = true
  config.vm.network :private_network, ip: ip

  config.vm.provision :shell, inline: "cd #{path}; cp ./cnf/sources.list /etc/apt/sources.list; ./build/vagrant.sh #{project}; ./build/install.sh"
end
