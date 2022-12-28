.releases | getpath([$v]) | .[] | select (.packagetype == "sdist") | {"name": $name, "filename": .filename, "version": $v, "sha256": .digests.sha256 }
