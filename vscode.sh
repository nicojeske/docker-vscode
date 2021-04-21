#! /usr/bin/env bash
export $(dbus-launch)
dbus-launch
gnome-keyring-daemon --start --daemonize --components=secrets
echo '123' | gnome-keyring-daemon -r -d --unlock
gnome-keyring-daemon --login
 
#Start the VSCode app
code --user-data-dir /vscode
 
#Keep the container running...
tail -f /dev/null
