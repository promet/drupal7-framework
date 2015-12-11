#!/bin/bash

set -e
path="$(dirname "$0")"
pushd $path/..
base="$(pwd)";

drupal_base="$base/www"

while getopts ":r:d:" opt; do
  case $opt in
    r)
      # Drupal Root Directory
      drupal_base="$base/$OPTARG";
      ;;
    d)
      # Drush Command
      drush="$OPTARG";
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      echo "
Usage: install.sh [-r DRUPAL_ROOT] [-d \"DRUSH COMMAND\"]
 Examples:
 `basename $0`                     # Installs in 'www' using 'drush -r www'
                                    or 'vendor/bin/drush -y -r www'

 `basename $0` -r docroot          # Installs in 'docroot' using
                                    'drush -r docroot' or
                                    'vendor/bin/drush -y -r www'

 `basename $0` -d \"drush @local\"   # Sets the drush command to what you want

 "
        exit 1;
      ;;
  esac
done

# Set the Default (or custom) drush commaand.
if [[ "$drush" == "" ]]; then
  if which drush > /dev/null; then
    drush="drush -r $drupal_base"
  else
    drush="$base/vendor/bin/drush -r $drupal_base"
  fi
fi
echo "DRUSH: $drush"
echo "DRUPAL BASE: $drupal_base"

if [[ -f "$base/.env" ]]; then
  echo "Using Custom ENV file at $base/.env"
  source "$base/.env"
else
  echo "Using Distributed ENV file at $base/env.dist"
  source "$base/env.dist"
fi

# If Composer.json exists and the composer command.
if [[ -e "$base/composer.json" ]] && which composer > /dev/null; then
  # Then run Composer
  echo "Installing dependencies with Composer.";
  composer install
fi
