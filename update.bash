#!/bin/bash
cd "$(dirname "$0")"

(
	# Ensure only one instance of this script is running
	flock -n 9 || exit 1

	# Set go path
	# which may not be set
	# if script is running in a noninteractive shell.
	source ~/dotfiles/sh/rc.d/11-gopath

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
) 9>/var/lock/log-hugo-update.lock
