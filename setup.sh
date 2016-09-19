#!/usr/bin/env bash

echo "Git hook setup..."

# Find the location of the script.
HOOKS_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# If writing to init.templatedir would overwrite an existing value,
# cache the old value away.
gitconfig_init_templatedir=`git config --global --get init.templatedir`
gitconfig_init_templatedirOLD=`git config --global --get init.templatedirOLD`
if [[ ("${#gitconfig_init_templatedir}" > 0) && ("${#gitconfig_init_templatedirOLD}" == 0) ]]; then
  echo "Old value of git variable init.templatedir copied to init.templatedirOLD"
  git config --global init.templatedirOLD "$gitconfig_init_templatedir"
fi

# OK, now, write (or overwrite) git config variables.

# Git itself will copy the bootstrapping hooks from this location into new repos.
git config --global init.templatedir "$HOOKS_DIRECTORY/githooks_bootstrap"

# In turn, the bootstrap hooks will read this variable to figure out where to
# point the symlinks for the *real* hooks to.
git config --global hooks.symlinksourcerepo "$HOOKS_DIRECTORY"

echo "...done with git hook setup"
