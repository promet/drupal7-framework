#!/bin/bash

[[ -z `which composer` ]] && curl -sS https://getcomposer.org/installer | php && cp composer.phar /usr/bin/composer && rm composer.phar || true
[[ -z `which git` ]] && apt-get update -y && apt-get install -q -y git || true
if [[ ! -f /opt/phantomjs ]]
then
  wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-linux-x86_64.tar.bz2 -O - 2>/dev/null | tar xj -C /tmp
  cp /tmp/phantom*/bin/phantomjs /opt
fi

/opt/phantomjs --webdriver=8643 &> /dev/null &
