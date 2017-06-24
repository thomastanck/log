#!/bin/bash
cd "$(dirname "$0")"

git pull

mv thomastanck.github.io/.git .tmpgit
rm -rf thomastanck.github.io
mkdir thomastanck.github.io
mv .tmpgit thomastanck.github.io/.git
hugo

cd thomastanck.github.io
git add .
git commit -m "Update site."
git push
cd ..

git add thomastanck.github.io
git commit -m "Update site."
git push
