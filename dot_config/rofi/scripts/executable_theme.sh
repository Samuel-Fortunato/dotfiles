#!/bin/bash

# theme.sh - Unified theme manager with Spotify live wallpaper and manual selection
# Usage:
#   theme.sh            - Show interactive rofi menu (pick wallpaper or start Spotify mode)
#   theme.sh --daemon   - Run Spotify background daemon (usually started by menu)
#   theme.sh --kill     - Kill the Spotify daemon

# Configuration
WP_DIR="$HOME/Pictures/Wallpapers"
TMP_DIR="/tmp/spotify_bg"
PID_FILE="/tmp/spotify-bg.pid"
FILL_COLOR="000000"
TRANSITION_TYPE="wipe"
TRANSITION_ANGLE=270
TRANSITION_STEP=30

# Different resize modes
MANUAL_RESIZE="crop" # For manual wallpaper selection
SPOTIFY_RESIZE="fit" # For Spotify mode

# Show wallpaper preview
GRID_THEME='
  window {
    width:      1000px;
	 height:     800px;
    location:   center;
    anchor:     center;
  }

  mainbox {
    children: [ "inputbar", "listview" ];
  }

  listview {
    columns:       3;
    lines:         3;
    cycle:         true;
    dynamic:       true;
    layout:        vertical;
    flow:          horizontal; /* This fixes the scrolling direction */
    fixed-columns: true;
    spacing:       5px;
  }

  element {
    orientation:   vertical; /* Text below image */
    padding:       0px;
    border-radius: 15px;
    spacing:       0px;
  }

  element-icon {
    size:            212px; /* Large preview */
    cursor:          inherit;
    horizontal-align: 0.5;
    /* This forces the aspect ratio to look better with landscape images */
    expand:          false; 
  }

  element-text {
    horizontal-align: 0.5;
    vertical-align:   0.5;
    expand:           true;
  }
'
# Ensure directories exist
mkdir -p "$WP_DIR" "$TMP_DIR"

# Function to set wallpaper and generate colors
# Usage: set_wallpaper_and_colors <img_path> <resize_mode>
set_wallpaper_and_colors() {
	local img_path="$1"
	local resize_mode="$2"

	if [[ ! -f "$img_path" ]]; then
		echo "Error: Image not found: $img_path"
		return 1
	fi

	# Generate color palette first
	# -n: skip wallpaper
	wal -i "$img_path" -n -q --saturate 0.2 --backend haishoku

	# Read color0 from pywal's JSON for the fill color
	local fill_color
	fill_color=$(python3 -c "
		import json
		with open('${HOME}/.cache/wal/colors.json') as f:
			 data = json.load(f)
		print(data['colors']['color0'].lstrip('#'))
		")

	# Set wallpaper
	awww img "$img_path" \
		--resize "$resize_mode" \
		--fill-color "$fill_color" \
		--transition-type "$TRANSITION_TYPE" \
		--transition-step "$TRANSITION_STEP" \
		--transition-angle "$TRANSITION_ANGLE"

	# Reload waybar to pick up new colors
	pkill -SIGUSR2 waybar
	sleep 0.1
	if [ -f /tmp/waybar_hidden ]; then
		killall -SIGUSR1 waybar
	fi

	# apply hyprland theme
	hyprctl reload

	# Aplly nvim theme
	for sock in /run/user/1000/nvim-*; do
		if [ -S "$sock" ]; then
			nvim --server "$sock" --remote-expr "execute('colorscheme pywal16')"
		fi
	done

	# zathura
	gdbus call --session \
		--dest org.freedesktop.DBus \
		--object-path /org/freedesktop/DBus \
		--method org.freedesktop.DBus.ListNames |
		tr ',' '\n' |
		grep -o "org\.pwmt\.zathura[^'\"]*" |
		while read -r name; do
			gdbus call --session \
				--dest "$name" \
				--object-path /org/pwmt/zathura \
				--method org.pwmt.zathura.SourceConfig
		done
}

# Function for Spotify daemon mode
daemon_mode() {
	echo "Starting Spotify background daemon (PID: $$)"
	echo $$ >"$PID_FILE"

	BG_PATH="$TMP_DIR/current_art.jpg"

	while true; do
		# Use playerctl to follow track changes
		playerctl -p spotify metadata --format '{{mpris:artUrl}}' --follow 2>/dev/null | while read -r url; do
			if [[ -n "$url" ]]; then
				# Download album art
				curl -s "$url" -o "$BG_PATH"
				# Optional: blur with ImageMagick (uncomment if magick is installed)
				# magick "$BG_PATH" -blur 0x50 "$BG_PATH"

				# Use SPOTIFY_RESIZE mode for Spotify album art
				set_wallpaper_and_colors "$BG_PATH" "$SPOTIFY_RESIZE"
			fi
		done
		sleep 5 # Fallback in case playerctl --follow fails
	done
}

# Function to kill the daemon
kill_daemon() {
	if [[ -f "$PID_FILE" ]]; then
		pid=$(cat "$PID_FILE")
		if kill -0 "$pid" 2>/dev/null; then
			kill "$pid"
			rm -f "$PID_FILE"
			echo "Spotify daemon (PID $pid) killed."
		else
			echo "Stale PID file found. Removing."
			rm -f "$PID_FILE"
		fi
	else
		# Fallback: try pkill
		pkill -f "theme.sh --daemon" 2>/dev/null && echo "Killed Spotify daemon (pkill)."
	fi
}

# Interactive menu
interactive_mode() {
	# Kill any running daemon first (so they don't conflict)
	kill_daemon

	CHOICE=$(echo -e " Pick Wallpaper\n Spotify Mode" | rofi -dmenu -i -p "Theme Mode:")

	case "$CHOICE" in
	*"Pick Wallpaper"*)
		# SELECTED=$(ls "$WP_DIR" | grep -E '\.(jpg|jpeg|png|gif)$' | rofi -dmenu -i -p "Wallpaper:")
		# if [[ -n "$SELECTED" ]]; then
		# 	WP_PATH="$WP_DIR/$SELECTED"
		# 	# Use MANUAL_RESIZE mode for manually selected wallpapers
		# 	set_wallpaper_and_colors "$WP_PATH" "$MANUAL_RESIZE"
		# 	# notify-send "Theme" "Wallpaper applied: $SELECTED"
		# fi

		SELECTED=$(
			for img in "$WP_DIR"/*; do
				[[ "$img" =~ \.(jpg|jpeg|png|webp|PNG|JPG)$ ]] || continue
				printf "%s\0icon\x1f%s\n" "$(basename "$img")" "$img"
			done | rofi \
				-dmenu \
				-i \
				-show-icons \
				-theme-str "$GRID_THEME" \
				-p "" \
				-name "wallpaper-picker"
		)

		if [[ -n "$SELECTED" ]]; then
			WP_PATH="$WP_DIR/$SELECTED"
			# Use MANUAL_RESIZE mode for manually selected wallpapers
			set_wallpaper_and_colors "$WP_PATH" "$MANUAL_RESIZE"
			# notify-send "Theme" "Wallpaper applied: $SELECTED"
		fi

		;;
	*"Spotify Mode"*)
		# Start daemon in background (detached)
		nohup "$0" --daemon >/dev/null 2>&1 &
		# notify-send "Theme" "Spotify Live Theming Activated"
		;;
	*)
		# Do nothing if cancelled
		;;
	esac
}

# Main argument parsing
case "${1:-}" in
--daemon)
	daemon_mode
	;;
--kill)
	kill_daemon
	;;
--help | -h)
	echo "Usage: $0 [--daemon|--kill|--help]"
	echo "  (no args)  Show interactive menu"
	echo "  --daemon   Run Spotify background daemon"
	echo "  --kill     Kill the running daemon"
	exit 0
	;;
*)
	interactive_mode
	;;
esac
