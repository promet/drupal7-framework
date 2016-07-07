#!/bin/bash
set -e
path="$(dirname "$0")"
source "$path/common.sh"

# Change to the Drupal Directory Just In Case
pushd "$drupal_base"

# This was added because of upgrades like Rules 2.8 to 2.9 and Feeds alpha-9 to beta-1 where
# new code and database tables are added and running other code will cause white screen until
# the updates are run.
echo "Initial Update so updated modules can work."
$drush updb -y
echo "Rebuilding registry and clearing caches."
$drush rr
echo "Enabling modules"
$drush en $(echo $DROPSHIP_SEEDS | tr ':' ' ') -y
$drush cc drush
echo "Running manifests"
$drush kw-m
echo "Set default theme"
$drush scr $base/build/scripts/default_set_theme.php
echo "Clearing caches one last time."
$drush cc all

chmod -R +w "$base/cnf"
chmod -R +w "$base/www/sites/default"
