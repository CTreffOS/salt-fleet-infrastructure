#!/bin/sh

# A little helper to figure out if salt is conneected and working...
if [ "$(id -u)" -ne 0 ]; then
  echo >&2 "Error: script not running as root! Exiting..."
  exit 1
fi

echo "*** Is the SALT minion active?"
systemctl --no-pager status salt-minion
echo ""

echo "*** Is the SALT VPN connected (look for latest handshake)?"
wg show
echo ""

echo "*** Is the SALT master reachable with VPN?"
ping -c 4 salt-via-wg
echo ""

echo "*** Is the SALT master reachable without VPN?"
ping -c 4 salt
