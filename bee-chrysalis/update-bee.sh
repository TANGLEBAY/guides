#!/bin/bash
red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
nc='\033[0m'
user=$(whoami)
if [ "$user" = "bee" ]; then
    status="$(systemctl show -p ActiveState --value bee)"
    if [ "$status" != "active" ]; then
        cd /var/lib/bee
        checkbee=$(git pull)
        if [ "$checkbee" != "Already up to date." ]; then
            echo ""
            echo -e $yellow "Updating rust..." $nc
            echo ""
            rustup update
            if [ -d "/var/lib/bee/bee-node/src/plugins/dashboard/frontend" ]; then
                echo ""
                echo -e $yellow "Updating the dashboard..." $nc
                echo ""
                cd /var/lib/bee/bee-node
                git submodule update --init
                cd /var/lib/bee/bee-node/src/plugins/dashboard/frontend
                npm install
                npm run build-bee
            fi
            echo ""
            echo -e $yellow "Updating Bee..." $nc
            echo ""
            cd /var/lib/bee/bee-node
            cargo build --release --features dashboard
            if [ "$1" != "noreset" ]; then
                echo ""
                echo -e $yellow "Removing old database and snaphot" $nc
                echo ""
                rm -rf /var/lib/bee/target/release/storage /var/lib/bee/target/release/snapshots
                echo ""
                echo -e $yellow "Creating backup of bee configuration (/var/lib/bee/target/release/config.toml.bak)..." $nc
                echo ""
                mv /var/lib/bee/target/release/config.toml /var/lib/bee/target/release/config.toml.bak
                cp -r /var/lib/bee/bee-node/config.example.toml /var/lib/bee/target/release/config.toml
                echo ""
                echo -e $yellow "Adding identity private key to new configuration..." $nc
                echo ""
                privkey=$(cat /var/lib/bee/target/release/config.toml.bak | grep "identity_private_key")
                sed -i 's/^.*identity_private_key.*$/'"$privkey"'/' /var/lib/bee/target/release/config.toml
            else
                echo -e $yellow "Skipping because of noreset argument..." $nc
            fi
            echo ""
            echo -e $green "Bee successfully updated!" $nc
            echo ""
            echo -e $red "Dont forget to update your configuration file!" $nc
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
else
    echo ""
    echo -e $red "Please switch to user bee (sudo su bee) before continue!" $nc
    echo ""
fi
exit 0
