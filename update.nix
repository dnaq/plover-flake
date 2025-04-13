{
  writeShellApplication,
  curl,
  jq,
  inputs,
}:
writeShellApplication {
  name = "update";

  runtimeInputs = [
    curl
    jq
  ];

  text = ''
    jq '.[]' -r "${inputs.plover_plugins_registry}/registry.json" |
    while read -r plugin;
    do
      info=$(curl -Ls https://pypi.org/pypi/"$plugin"/json)
      version=$(echo "$info" | jq -r .info.version)
      echo "$info" | jq --arg v "$version" --arg name "$plugin" -f filter.jq
    done | jq -s . > plugins.json
  '';
}
