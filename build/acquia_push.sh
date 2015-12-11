#!/bin/bash

set -e

if [ -z $1 ]; then
  echo "
 Usage:

 acquia_push.sh ACQUIA_ARTIFACT_SITE_DIRECTORY

 This command uses the site in the current build as a template to create an
  artifact site so you can commit it to an Acquia Git Repository.

 Examples:
 /var/www/sites/project.dev/build/acquia_push.sh /var/www/sites/project.acquia

 "
  exit 1;
fi

base="$(dirname "$0")/.."
acquia_base="$1"
drupal_root="$acquia_base/docroot"

# Only works in bash
shopt -s extglob
sudo rm -rf $acquia_base/!(.git)

echo "Copying files forming the artifact site"
rsync -av --force --progress --exclude ".env" --exclude ".git" --exclude "www/sites/default/files" --exclude "build/ref" --exclude "private" --exclude "martincountymail" "$base" "$acquia_base" > /dev/null;
echo -e "\n\nRemoving Drupal .gitignore\n\n"
rm "$drupal_root/.gitignore"
echo -e "Removing items from .gitignore\n\n"
sed -i -e '/^docroot$/d' "$acquia_base/.gitignore"
sed -i -e '/^vendor$/d' "$acquia_base/.gitignore"
sed -i -e '/^docroot\/sites\/\*\/settings.php$/d' "$acquia_base/.gitignore"
echo -e "****************** Review .gitignore please ********************\n\n"
cat "$acquia_base/.gitignore"

