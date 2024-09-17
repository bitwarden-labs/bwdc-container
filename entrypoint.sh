#!/bin/bash

# Generate a random passphrase
RANDOM_PASSPHRASE=$(openssl rand -base64 32)

# Export DBUS session and start DBUS
export $(dbus-launch)

# Start DBUS and GNOME keyring
dbus-launch
gnome-keyring-daemon --start --daemonize --components=secrets

# Unlock the keyring with the random passphrase
echo "$RANDOM_PASSPHRASE" | gnome-keyring-daemon -r -d --unlock

# Print the generated passphrase (optional, for debugging purposes)
echo "Generated random passphrase: $RANDOM_PASSPHRASE"

# Execute the main process of the container
exec "$@"
