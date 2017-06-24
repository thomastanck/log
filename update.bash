#!/bin/bash
cd "$(dirname "$0")"

mv thomastanck.github.io/.git .tmpgit
rm -rf thomastanck.github.io
mkdir thomastanck.github.io
mv .tmpgit thomastanck.github.io/.git
hugo
