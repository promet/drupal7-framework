#!/bin/bash

set -e
path=$(dirname "$0")
base=$PWD/$path/..
[[ -f $base/.env ]] && source $base/.env || source $base/env.dist;
echo "Running Behat tests with flags: $@"
# check to see if phantomjs is running. If not, lets run it.
if [[ `pgrep phantomjs` -eq 0 ]]
then
  echo "Starting up PhantomJs"
  /opt/phantomjs --webdriver=8643 &> /dev/null &
fi
$base/vendor/bin/behat "$@"
