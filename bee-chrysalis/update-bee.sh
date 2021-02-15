#!/bin/bash
red='\033[1;31m'
green='\033[1;32'
nc='\033[0m'
status="$(systemctl show -p ActiveState --value bee)"
if [ "$status" != "active" ]; then
    cd /var/lib/bee
    checkbee=$(git pull)
    if [ "$checkbee" != "Already up to date." ]; then
        cd /var/lib/bee/bee-node
        git submodule update --init
        cd /var/lib/bee/bee-node/src/plugins/dashboard/frontend
        npm install
        npm run build-bee
        cd /var/lib/bee/bee-node
        cargo build --release --features dashboard
        rm -rf /var/lib/bee/target/release/storage/alphanet /var/lib/bee/target/release/snapshots/alphanet
        mv /var/lib/bee/target/release/config.toml /var/lib/bee/target/release/config.toml.bak
        cp -r /var/lib/bee/bee-node/config.example.toml /var/lib/bee/target/release/config.toml
        privkey=$(cat /var/lib/bee/target/release/config.toml.bak | grep "identity_private_key")
        sed -i 's/^.*identity_private_key.*$/'"$privkey"'/' /var/lib/bee/target/release/config.toml
        echo ""
        echo -e $green "Bee successfully updated!" $nc
        echo ""
        echo -e $red "Dont forget to update your configuration file!"
        echo ""
    else
        echo ""
        echo -e $green "Bee is already up2date!" $nc
        echo ""
    fi
else
    echo ""
    echo -e $red "Please stop Bee first to be able to continue with the update!" $nc
    echo ""
fi

exit 0
