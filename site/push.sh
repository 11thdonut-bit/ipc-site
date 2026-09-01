#!/bin/bash
# Publishes the current build to https://github.com/11thdonut-bit/ipc-site
# Safe by design: it refuses to run if the push would delete anything.
set -e

SRC="$HOME/Desktop/IPC Design/site"
CLONE="$HOME/Desktop/ipc-site"
REPO="https://github.com/11thdonut-bit/ipc-site.git"

echo "==> Getting the current state of the repo"
if [ -d "$CLONE/.git" ]; then
  git -C "$CLONE" fetch --quiet origin main
  git -C "$CLONE" checkout --quiet main
  git -C "$CLONE" reset --hard --quiet origin/main
else
  git clone --quiet "$REPO" "$CLONE"
fi

echo "==> Copying the new build in"
cp "$SRC/index.html"  "$CLONE/"
cp "$SRC/sitemap.xml" "$CLONE/"
cp "$SRC/robots.txt"  "$CLONE/"
cp "$SRC/.nojekyll"   "$CLONE/"

cd "$CLONE"

echo "==> Safety checks"
DELETED=$(git diff --diff-filter=D --name-only HEAD | wc -l | tr -d ' ')
if [ "$DELETED" != "0" ]; then
  echo "STOP: this would delete $DELETED file(s):"
  git diff --diff-filter=D --name-only HEAD
  exit 1
fi
for f in CNAME favicon.ico README.md; do
  [ -f "$f" ] || { echo "STOP: $f is missing from the working tree."; exit 1; }
done
[ "$(cat CNAME)" = "inpl.space" ] || { echo "STOP: CNAME is not inpl.space."; exit 1; }
echo "    CNAME intact (inpl.space), favicon.ico intact, nothing deleted."

echo
echo "==> This is what will be published:"
git status --short
echo

read -r -p "Push to inpl.space? [y/N] " ok
[ "$ok" = "y" ] || [ "$ok" = "Y" ] || { echo "Cancelled. Nothing was pushed."; exit 0; }

git add -A
git commit -q -m "New site"
git push origin main

echo
echo "Pushed. GitHub Pages usually redeploys within a minute."
echo "Then open https://inpl.space and hard-refresh with Cmd-Shift-R."
