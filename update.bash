#!/bin/bash
cd "$(dirname "$0")"

(
	# Ensure only one instance of this script is running
	flock -n 9 || exit 1

	# In case .bashrc isn't soured e.g. in a noninteractive terminal
	# This happens when you run a command via `ssh host 'command'`
	source ~/.bashrc force

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
