#!/bin/bash

set -e
path=$(dirname "$0")
base=$(cd $path/.. && pwd)
drush="$base/vendor/bin/drush.php $drush_flags -y -r $base/www"

if [[ -f .env ]]; then 
  source .env
else
  echo "No env file found. Please create one. You can use env.dist as an example."
  exit 1
fi
