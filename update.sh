#!/usr/bin/env bash

jq '.[]' -r $PLUGINREGISTRY |
while read -r plugin;
do
  #echo $plugin
  info=$(curl -Ls https://pypi.org/pypi/${plugin}/json)
  version=$(echo "$info" | jq -r .info.version)
  #echo $version
  echo $info | jq --arg v "$version" --arg name $plugin -f filter.jq
done | jq -s . > plugins.json
