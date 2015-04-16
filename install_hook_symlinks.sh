HOOKS_DIRECTORY=`git config --global --get hooks.symlinksourcerepo`

echo "Creating and registering symbolic links in .git/hooks..."
if [[ -d "$1/.git/hooks" || -L "$1/.git/hooks" ]]; then
  if [[ -d "$1/.git/hooksOLD" || -L "$1/.git/hooksOLD" ]]; then
    rm -rf "$1/.git/hooksOLD"
  fi
  echo "Backing up $1/.git/hooks to $1/.git/hooksOLD"
  mv -f "$1/.git/hooks" "$1/.git/hooksOLD"
fi
ln -is "$HOOKS_DIRECTORY" "$1/.git/hooks"

echo "...done"
