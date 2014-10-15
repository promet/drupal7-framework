Vagrant.configure("2") do |config|

  # tunables
  env_prefix  = ENV['DRUPAL_VAGRANT_ENV_PREFIX'] || 'DRUPAL_VAGRANT'
  ip          = ENV["#{env_prefix}_IP"] || '10.33.36.11'
  project     = ENV["#{env_prefix}_PROJECT"] || 'drupal'
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

  config.vm.provision :shell, inline: <<SCRIPT
  set -ex
  apt-get update && apt-get install -q -y git-core
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer;
  cp #{path}/cnf/sources.list /etc/apt/sources.list;
  su vagrant -c 'cd #{path} && composer install;
  cd #{path} && [[ -f .env ]] && source .env || cp env.dist .env && source env.dist && build/install.sh;'
  #{path}/build/vagrant.sh
SCRIPT
end
