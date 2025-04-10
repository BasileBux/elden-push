#!/bin/bash

get_cursor_position() {
    # Save current terminal settings
    exec < /dev/tty
    oldstty=$(stty -g)
    stty raw -echo min 0

    # Send escape sequence to query cursor position
    echo -en "\033[6n"
    
    # Read the response
    read -r -d R response
    
    # Restore terminal settings
    stty $oldstty
    
    # Extract row and column from response
    row=$(echo "$response" | cut -d[ -f2 | cut -d\; -f1)
    col=$(echo "$response" | cut -d\; -f2)
    
    echo "$row"
}

# Check if ImageMagick (convert command) is installed
if ! command -v convert &> /dev/null; then
    echo "Error: ImageMagick (convert command) not found. Please install it." >&2
    exit 1
fi

if ! command -v kitty &> /dev/null; then
    echo "Error: Kitty terminal not found. Please install it." >&2
    exit 1
fi

BACKGROUND=~/scripts/elden-ring/assets/background.png # 1920 x 1080
TEXT=~/scripts/elden-ring/assets/text.png # 1920 x 1080

# Get terminal/pane size in pixels
if [[ -n "$TMUX" ]]; then
    # Inside tmux: get pane dimensions
    WIDTH=$(tmux display-message -p '#{pane_width}')
    HEIGHT=$(tmux display-message -p '#{pane_height}')
    # Convert from cells to pixels (assuming default font size)
    WIDTH=$((WIDTH * 10))  # Approximate character width in pixels
    HEIGHT=$((HEIGHT * 20))  # Approximate character height in pixels
else
    # Not in tmux: get window size from kitty
    size_str=$(kitty +kitten icat --print-window-size)
    # Replace 'x' with a space so read can parse width and height
    read -r WIDTH HEIGHT <<< "${size_str/x/ }"
fi

if [[ -z "$WIDTH" || -z "$HEIGHT" ]]; then
    echo "Error: Could not get terminal/pane size." >&2
    exit 1
fi

# Create a temporary file for the combined image
TMP_IMAGE=$(mktemp --suffix=.png)

# Ensure temporary file is deleted on exit
trap 'rm -f "$TMP_IMAGE"' EXIT

if ! magick "$BACKGROUND" -resize "${WIDTH}x${HEIGHT}!" \( "$TEXT" -resize "${WIDTH}x${HEIGHT}" \) -gravity center -composite "$TMP_IMAGE"; then
    echo "Error: Failed to combine images using ImageMagick." >&2
    exit 1
fi

rows=$(tput lines)
rows=$((rows - 2))

kitty +icat --transfer-mode=file --align=left --place "${WIDTH}x${HEIGHT}@0x0" "$TMP_IMAGE"

printf "\033[0;0H"
printf "\033[${rows};1H"

sleep 2

if [[ -n "$TMUX" ]]; then
    clear
else
    kitty +icat --clear
fi
