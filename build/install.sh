#!/bin/bash
set -e
path=$(dirname "$0")
source $path/common.sh

echo "Installing Drupal minimal profile.";
$drush si minimal --account-name=admin --account-pass=drupaladm1n
source $path/update.sh
