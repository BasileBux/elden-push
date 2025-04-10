# Elden push

A small script which will display the elden ring victory banner in your terminal.
The animation is meant to play when you push some code with git. However, the script
is only visual and doesn't do anything else. So you will need to write an alias
to run the script and then push your code. The script also plays the elden ring
victory sound effect. 

This script uses the kitty image protocol and specifically the `icat` command. So
you will need to have kitty installed and use this inside a terminal which supports
the kitty image protocol.

> [!WARNING]
> This doesn't work in tmux and other tui integrated terminals yet. It might be
> the case one day, specifically for tmux but I don't know yet. 

## Usage

You need to clone this repo. When running the script, it will check if there
already is a cached animation for your terminal size. If not, it will create one
which might take a bit of time. The cache is dependent on the terminal size (it
will generate cache for every new terminal size. It is stored in the script's
directory. You can safely delete the whole cache directory to free up space. 

## Resources

- https://rezuaq.be/new-area/image-creator/

## Disclaimer

The assets used in this script (images, sound effects) are from the game Elden
Ring, developed by FromSoftware and published by Bandai Namco Entertainment. I
do not own the rights to any of these assets.

The idea for displaying a game banner upon completing a task was inspired by the
[Dark Souls Notifications Firefox extension](https://github.com/komlev/darksouls-notifications)
by komlev. And some memes on twitter. 
