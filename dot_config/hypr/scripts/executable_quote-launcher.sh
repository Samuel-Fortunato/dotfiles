#!/usr/bin/env bash

QUOTE_FILE="$HOME/.config/hypr/scripts/quotes.txt"

if [ ! -f "$QUOTE_FILE" ]; then
    echo "Error: quotes.txt not found!"
    exit 1
fi

# Pick a single random line
RAW_QUOTE=$(shuf -n 1 "$QUOTE_FILE")

# Convert literal \n strings into actual line breaks
PROCESSED_QUOTE=$(echo -e "$RAW_QUOTE")

# Launch Rofi with support for wrapped/multiline text
rofi -e "$PROCESSED_QUOTE" -theme-str '
window {
    width: 55%;
    location: center;
    anchor: center;
    border: 3px;
    border-radius: 12px;
    padding: 40px;
}
textbox {
    font: "Sans Bold 26";
    horizontal-align: 0.5;
    vertical-align: 0.5;
    wrap: true;
}'
