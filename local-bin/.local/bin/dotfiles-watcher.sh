#!/usr/bin/env bash

DOTFILES_DIR="$HOME/.dotfiles" # Adjust if your Stow repo is located elsewhere
COOLDOWN=300                   # Cooldown duration in seconds (5 minutes)

cd "$DOTFILES_DIR" || exit 1

while true; do
	# Wait for file changes while ignoring the internal .git directory
	inotifywait -r -e modify,create,delete,move --exclude '\.git/' "$DOTFILES_DIR" &>/dev/null

	# Cooldown period to allow active editing sessions to settle
	sleep "$COOLDOWN"

	# Check if uncommitted changes still remain
	if [[ -n $(git status --porcelain) ]]; then
		notify-send -u normal \
			-a "Dotfiles Watcher" \
			"Dotfiles Modified" \
			"Uncommitted changes detected in your dotfiles repository."
	fi
done
