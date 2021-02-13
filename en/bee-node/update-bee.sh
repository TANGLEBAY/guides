#!/bin/bash
user=$1
cd /var/lib/bee
checkbee=$(sudo -u $user git pull)
if [ "$checkbee" != "Already up to date." ]; then
    sudo systemctl stop bee
    cd /var/lib/bee/bee-node
    sudo -u $user git submodule update --init &&
    cd /var/lib/bee/bee-node/src/plugins/dashboard/frontend
    sudo -u $user npm install &&
    sudo -u $user npm run build-bee &&
    cd /var/lib/bee/bee-node
    sudo -u $user rm -rf /var/lib/bee/target/release/storage/alphanet/* &&
    sudo -u $user rm -rf /var/lib/bee/target/release/snapshots/alphanet/* &&
    sudo -u $user cargo build --release --features dashboard &&
    sudo -u $user cp /var/lib/bee/target/release/config.toml /var/lib/bee/target/release/config.toml.bak &&
    sudo systemctl start bee
fi
exit 0