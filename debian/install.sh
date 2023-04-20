#!/bin/bash
set -e

# download information
TEAMSPEAK_CHECKSUM=775a5731a9809801e4c8f9066cd9bc562a1b368553139c1249f2a0740d50041e
TEAMSPEAK_URL=https://files.teamspeak-services.com/releases/server/3.13.7/teamspeak3-server_linux_amd64-3.13.7.tar.bz2

# dummy user creation used when no UID or GID is specified
echo
echo "Creating user..."
addgroup --gid 9987 ts3server
adduser --uid 9987 --ingroup ts3server --home /var/ts3server --shell /sbin/nologin --no-create-home --disabled-password ts3server
echo

# permissions
echo
echo "Setting permissions..."
install -d -o ts3server -g ts3server -m 770 /var/ts3server /var/run/ts3server
install -d -o ts3server -g ts3server -m 775 /opt/ts3server

# server installation
echo
echo "Downloading Teamspeak3 Server..."
wget -qO server.tar.bz2 $TEAMSPEAK_URL

echo
echo "Verifying checksum..."
echo "$TEAMSPEAK_CHECKSUM server.tar.bz2" | sha256sum -c -

echo
echo "Extracting..."
tar -xf server.tar.bz2 -C /opt/ts3server --strip-components=1
rm server.tar.bz2
chmod g-w,o-w -R /opt/ts3server

echo
echo "Moving libs..."
mv /opt/ts3server/*.so /opt/ts3server/redist/* /usr/local/lib
ldconfig /usr/local/lib
