#!/bin/bash
set -e
path=$(dirname "$0")
true=`which true`
source $path/common.sh

echo "Installing Drupal minimal profile.";
# Setting PHP Options so that we don't fail while sending mail if a mail sytem
# doesn't exist.
PHP_OPTIONS="-d sendmail_path=$true" $drush si minimal --account-name=admin --account-pass=drupaladm1n
source $path/update.sh
