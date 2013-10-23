#!/bin/bash

# Find the location of the script.
DOTFILE_DIRECTORY=`pwd`

git config --global init.templatedir $DOTFILE_DIRECTORY
echo "From now on, when creating a repo by running 'git init', the new repo will"
echo "use $DOTFILE_DIRECTORY as its git hooks directory."
echo "It is safe to run 'git init' in an existing repo to re-initialize this."
echo ""
