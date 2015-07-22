#!/bin/bash

set -e
project=$1
path=$(dirname "$0")
base=$(cd $path/.. && pwd)

sudo apt-get update -y
echo "Get Composer"
[[ -z `which composer` ]] && curl -sS https://getcomposer.org/installer | php && cp composer.phar /usr/bin/composer && rm composer.phar || true
composer self-update
echo "Check for Version Control Tools"
[[ -z `which git` ]] && apt-get install -q -y git || true
[[ -z `which svn` ]] && apt-get install -q -y subversion || true
if [[ ! -f /opt/phantomjs ]]
then
  echo "Downloading PhantomJS"
  wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-linux-x86_64.tar.bz2 -O - 2>/dev/null | tar xj -C /tmp
  sudo cp /tmp/phantom*/bin/phantomjs /opt
  # We should also do this on machine boot
  sudo sed -i '$i/opt/phantomjs --webdriver=8643 &> /dev/null &' /etc/rc.local
fi

echo "Starting up PhantomJS"
[[ -z `pgrep phantomjs` ]] && /opt/phantomjs --webdriver=8643 &> /dev/null &

if [[ -z $project ]]
then
  exit
fi

cd $base

[[ ! -z `grep "PROJECT=default" env.dist` ]] && sed -i "s/default/$project/" env.dist

if [[ ! -f .env ]]
then
  echo "Creating Environment File"
  echo "source env.dist" > .env
fi
source .env
if [[ -f default.module ]]
then
  echo "Setting up Default Project Modules."
  mkdir modules/custom/$project
  mv default.module modules/custom/$project/$project.module
  mv default.info modules/custom/$project/$project.info
  sed -i s/default/$project/g modules/custom/$project/$project.*
  echo "*****************************************"
  echo "* Don't forget to Commit these changes. *"
  echo "*****************************************"
fi

if [[ ! -z `grep "# Promet Drupal 7 Framework" README.md` ]]
then
  sed -i "1s/^# Promet Drupal 7 Framework/# $project/" README.md
  sed -i "s/drupalproject/$project/" README.md
fi
