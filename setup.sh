#!/bin/bash

# Find the location of the script.
DOTFILE_DIRECTORY=`pwd`

echo "Creating symbolic links in .git/hooks..."
rm -rf "$1/.git/hooks"
ln -is "$DOTFILE_DIRECTORY" "$1/.git/hooks"

echo "...done"
