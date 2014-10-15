#!/bin/bash
set -e
path=$(dirname "$0")
source $path/common.sh

echo "Enabling modules";
$drush en $(echo $DROPSHIP_SEEDS | tr ':' ' ')
echo "Rebuilding registry and clearing caches.";
$drush rr
$drush cc drush
echo "Running manifests"
$drush kw-m
echo "Set default theme";
$drush scr $base/build/scripts/default_set_theme.php
echo "Clearing caches one last time.";
$drush cc all

chmod -R +w $base/cnf
chmod -R +w $base/www/sites/default
