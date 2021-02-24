#!/bin/bash
red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
nc='\033[0m'
node=$(whoami)
if [ "$node" = "hornet" ]; then
    status="$(systemctl show -p ActiveState --value $node)"
    if [ "$status" != "active" ]; then
        cd /var/lib/$node
        checkgit=$(git pull)
        if [ "$checkgit" != "Already up to date." ]; then
            echo ""
            echo -e $yellow "=> Creating backup of configuration files..." $nc
            echo ""
            mkdir -p /var/lib/$node/backup
            cp /var/lib/$node/config_chrysalis_testnet.json /var/lib/$node/backup
            cp /var/lib/$node/peering.json /var/lib/$node/backup
            echo ""
            echo -e $yellow "=> Reset hornet repository..." $nc
            echo ""
            git reset --hard origin/develop
            git pull
            echo ""
            echo -e $yellow "=> Building Hornet..." $nc
            echo ""
            if [ -f "/var/lib/$node/hornet" ]; then
            rm -rf /var/lib/$node/hornet
            fi
            go build -o hornet
            if [ "$1" != "noreset" ]; then
                echo ""
                echo -e $yellow "=> Removing old database and snaphot" $nc
                echo ""
                rm -rf /var/lib/$node/testnetdb /var/lib/$node/snapshots
                cat /var/lib/$node/backup/peering.json > /var/lib/$node/peering.json
                if [ -f "/var/lib/$node/hornet" ]; then
                    echo ""
                    echo -e $green "Hornet successfully updated!" $nc
                    echo ""
                    echo -e $red "Dont forget to update your configuration file!" $nc
                    echo ""
                else
                    echo ""
                    echo -e $red "Error while building bee, please check the logs and ask in Discord!" $nc
                    echo ""
                fi
            else
                cat /var/lib/$node/backup/peering.json > /var/lib/$node/peering.json
                echo ""
                echo -e $yellow "=> Skipping because of noreset argument..." $nc
                if [ -f "/var/lib/$node/hornet" ]; then
                    echo ""
                    echo -e $green "Hornet successfully updated!" $nc
                    echo ""
                else
                    echo ""
                    echo -e $red "Error when building Hornet, please check the logs and ask in Discord!" $nc
                    echo ""
                fi
            fi
        else
            echo ""
            echo -e $green "Hornet is already up2date!" $nc
            echo ""
        fi
    else
        echo ""
        echo -e $red "Please stop Hornet first to be able to continue with the update!" $nc
        echo ""
    fi
else
    echo ""
    echo -e $red "Please switch to user bee (sudo su bee) before continue!" $nc
    echo ""
fi
exit 0
