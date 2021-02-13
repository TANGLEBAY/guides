#!/bin/bash
red='\033[1;31m'
nc='\033[0m'

status="$(systemctl show -p ActiveState --value bee)"
if [ "$status" != "active" ]; then
    cd /var/lib/bee
    checkbee=$(git pull)
    if [ "$checkbee" != "Already up to date." ]; then
        cd /var/lib/bee/bee-node
        git submodule update --init &&
        cd /var/lib/bee/bee-node/src/plugins/dashboard/frontend
        npm install &&
        npm run build-bee &&
        cd /var/lib/bee/bee-node
        rm -rf /var/lib/bee/target/release/storage/alphanet/* &&
        rm -rf /var/lib/bee/target/release/snapshots/alphanet/* &&
        cargo build --release --features dashboard &&
        mv /var/lib/bee/target/release/config.toml /var/lib/bee/target/release/config.toml.bak &&
        cp /var/lib/bee/bee-node/config.example.toml /var/lib/bee/target/release/config.toml
        privkey=$(cat /var/lib/bee/target/release/config.toml.bak | grep "identity_private_key")
        sed -i 's/identity_private_key.*/'$privkey'/' /var/lib/bee/target/release/config.toml
        clear
        echo ""
        echo -e $red "Edit OLD configuration to save neighbors..."
        echo ""
        read -n1 -s -r -p $'Press any key to continue...\n' key
        nano /var/lib/bee/target/release/config.toml.bak
        clear
        echo ""
        echo -e $red "Edit NEW configuration..."
        echo ""
        read -n1 -s -r -p $'Press any key to continue...\n' key
        nano /var/lib/bee/target/release/config.toml
        echo ""
        echo -e $red "Updating finished!" $nc
    else
        echo -e $red "Bee already up2date!" $nc
    fi
else
    echo -e $red "Please stop the bee node before updating!" $nc
fi

exit 0