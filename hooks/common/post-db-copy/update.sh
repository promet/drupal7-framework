#!/bin/sh

path="$(dirname "$0")"
site="$1"
target_env="$2"
source_branch="$3"
deployed_tag="$4"
repo_url="$5"
repo_type="$6"

echo "### Run Update Script ###"
echo "$path/../../../build/update.sh -d \"drush @$site.$target_env\""
$path/../../../build/update.sh -d "drush @$site.$target_env"
