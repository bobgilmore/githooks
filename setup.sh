#!/bin/bash

# Find the location of the script.
HOOKS_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Creating and registering symbolic links in .git/hooks..."
rm -rf "$1/.git/hooks"
ln -is "$HOOKS_DIRECTORY" "$1/.git/hooks"
git config --global hooks.symlinksourcerepo "$HOOKS_DIRECTORY"

echo "...done"
