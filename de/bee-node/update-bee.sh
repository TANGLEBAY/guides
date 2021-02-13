#!/bin/bash
red='\033[1;31m'
nc='\033[0m'

status="$(systemctl show -p ActiveState --value bee)"
if [ "$status" != "active" ]; then
    cd /var/lib/bee
    checkbee=$(git pull)
    if [ "$checkbee" = "Already up to date." ]; then
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
        echo ""
        echo -e $red "Bearbeite die ALTE Konfiguration um den private Key & die Nachbarn zu kopieren..."
        echo ""
        read -n1 -s -r -p $'Drücke eine beliebige Taste um forzufahren...\n'
        nano /var/lib/bee/target/release/config.toml.bak
        echo ""
        echo -e $red "Bearbeite die neue Konfiguration..."
        echo ""
        read -n1 -s -r -p $'Drücke eine beliebige Taste um forzufahren...\n'
        nano /var/lib/bee/target/release/config.toml
        echo ""
        echo -e $red "Bee erfolgreich aktualisiert!" $nc
    else
        echo ""
        echo -e $red "Bee ist bereits auf dem neuesten Stand!" $nc
        echo ""
    fi
else
    echo ""
    echo -e $red "Bitte stoppe zuerst Bee um mit der Aktualisierung fortfahren zu können!" $nc
    echo ""
fi

exit 0