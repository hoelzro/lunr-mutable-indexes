#!/bin/bash

set -e -u

# make sure the tree is clean
if git status --porcelain | grep -q . ; then
    echo "Git tree is dirty"
    exit 1
fi

package_json_version=$(jq -r .version package.json)

# make sure the current HEAD is tagged with a tag that matches package.json's version
if !(git tag --list "v$package_json_version" --points-at=HEAD | grep -q .) ; then
    echo "HEAD is not tagged with version tag matching package.json"
    exit 1
fi

# make sure that tag is signed, too
if !(git verify-tag "v$package_json_version" &>/dev/null) ; then
    echo "Tag v$package_json_version is not properly signed"
    exit 1
fi

# make sure that the changelog has an entry for the current version
if !(package_json_version=$package_json_version perl -nle 'print if (/^\Q$ENV{package_json_version}\E/.../^\S/) && /^\s+[*]/' CHANGES | grep -q .); then
    echo "No entries in CHANGES for this version"
    exit 1
fi

# make sure that lunrMutable.version matches package.json
js_version=$(node -pe 'require("./lunr-mutable.js").version')

if [[ "$package_json_version" != "$js_version" ]]; then
    echo "JS module version doesn't match package.json version"
    exit 1
fi
