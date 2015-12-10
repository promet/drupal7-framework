set -e
path=$(dirname "$0")
base=$PWD/$path/..
[[ -f $base/.env ]] && source $base/.env || source $base/env.dist;
echo "Running Code Sniffer! Sniff allthethings!"
$base/vendor/bin/phpcs --config-set installed_paths $base/vendor/drupal/coder/coder_sniffer
$base/vendor/bin/phpcs --standard=Drupal --extensions="php,module,inc,install,test,profile,theme,js,css,info,txt" ./modules/custom
