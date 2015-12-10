#!/bin/bash

set -e
path=$(dirname "$0")
base=$(cd $path/.. && pwd)
drush="$PWD/vendor/bin/drush $drush_flags -y -r $base/www"

if [[ -f .env ]]; then
  source .env
else
  echo "No env file found. Please create one. You can use env.dist as an example."
  exit 1
fi
# Confirm our working directory
if [ ! -d $base/www ]; then
  mkdir $base/www
fi

# Then push it to memory
pushd $base/www

# Then run Composer
echo "Installing dependencies with Composer.";
cd $base
composer install
