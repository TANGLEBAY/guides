#!/bin/bash
red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
nc='\033[0m'
node=$(whoami)
if [ "$node" = "goshimmer" ]; then
    status="$(systemctl show -p ActiveState --value $node)"
    if [ "$status" != "active" ]; then
        cd /var/lib/goshimmer
        checkgit=$(git pull)
        if [ "$checkgit" != "Already up to date." ]; then
            echo ""
            echo -e $yellow "=> Creating backup of configuration files..." $nc
            echo ""
            mkdir -p /var/lib/goshimmer/backup
            cp /var/lib/goshimmer/config.json /var/lib/goshimmer/backup
            echo ""
            echo -e $yellow "=> Reset goshimmer repository..." $nc
            echo ""
            git reset --hard origin/master
            git pull
            echo ""
            echo -e $yellow "=> Building GoShimmer..." $nc
            echo ""
            if [ -f "/var/lib/goshimmer/goshimmer" ]; then
                rm -rf /var/lib/goshimmer/goshimmer
            fi
            if [ ! -f "/var/lib/goshimmer/build.sh" ]; then
                cp /var/lib/goshimmer/scripts/build.sh /var/lib/goshimmer/build.sh
            fi
            source /var/lib/goshimmer/build.sh
            if [ "$1" != "-noreset" ]; then
                echo ""
                echo -e $yellow "=> Removing old database" $nc
                echo ""
                rm -rf /var/lib/goshimmer/mainnetdb
                cat /var/lib/goshimmer/config.default.json > /var/lib/goshimmer/config.json
                if [ -f "/var/lib/goshimmer/goshimmer" ]; then
                    echo ""
                    echo -e $green "GoShimmer successfully updated!" $nc
                    echo ""
                    echo -e $red "Dont forget to update your configuration file!" $nc
                    echo ""
                else
                    echo ""
                    echo -e $red "Error while building goshimmer, please check the logs and ask in Discord!" $nc
                    echo ""
                fi
            else
                echo ""
                echo -e $yellow "=> Skipping because of noreset argument..." $nc
                if [ -f "/var/lib/goshimmer/goshimmer" ]; then
                    echo ""
                    echo -e $green "GoShimmer successfully updated!" $nc
                    echo ""
                else
                    echo ""
                    echo -e $red "Error when building GoShimmer, please check the logs and ask in Discord!" $nc
                    echo ""
                fi
            fi
        else
            echo ""
            echo -e $green "GoShimmer is already up2date!" $nc
            echo ""
        fi
    else
        echo ""
        echo -e $red "Please stop GoShimmer first to be able to continue with the update!" $nc
        echo ""
    fi
else
    echo ""
    echo -e $red "Please switch to user shimmer (sudo su shimmer) before continue!" $nc
    echo ""
fi
exit 0
