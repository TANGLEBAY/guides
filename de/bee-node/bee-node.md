# Benutzer bee erstellen
```sudo useradd -s /bin/bash -m bee```

# Pakete installieren
```sudo apt install git npm build-essential cmake pkg-config librocksdb-dev llvm clang libclang-dev libssl-dev apache2-utils software-properties-common certbot python3-certbot-nginx -y```


# Repo klonen
```sudo git clone https://github.com/iotaledger/bee.git --branch chrysalis-pt-2 /var/lib/bee```

# In das Verzeichnis wechseln
```cd /var/lib/bee/bee-node```

# Berechtigungen setzen
```sudo chown -R bee:bee /var/lib/bee```

# Benutzer wechseln
```su bee```

# Rust installieren
```curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh```
```source $HOME/.cargo/env```

# Git submodule initalisieren
```git submodule update --init```

# In das Verzeichnis des Dashboards wechseln
```cd /var/lib/bee/bee-node/src/plugins/dashboard/frontend```

# Module instalieren
```npm install```

# Build-bee ausführen
```npm run build-bee```

# Wieder zurück in das Verzeichnis wechseln
```cd /var/lib/bee/bee-node```

# Bee builden
```cargo build --release --features dashboard```

# Config kopieren
```cp config.example.toml /var/lib/bee/target/release/config.toml```

# In das erstelle Bee Verzeicnis wechseln
```cd /var/lib/bee/target/release```

# Identität generieren
```./bee p2p-identity```

# P2P private key kopiere und in config.toml einfügen & Nachbarn hinzufügen
```nano config.toml```

# Bee-User verlassen
`STRG+D` oder `exit` ins Terminal

# Service anlegen
```nano /lib/systemd/system/bee.service```

# Servicedatei kopieren
```sudo wget https://raw.githubusercontent.com/TANGLEBAY/tutorials/master/de/bee-node/bee.service -O /lib/systemd/system/bee.service```

# Daemon neu laden
```sudo systemctl daemon-reload```

# Bee Service aktivieren
```sudo systemctl enable bee```

# Bee starten
```sudo systemctl start bee```

# SSL Zertifikat beantragen (wichtig Port 80 öffnen!)
```sudo certbot --nginx -d node.meinedomain.de```

# Nginx Konfiguration ersetzen
```sudo rm -rf /etc/nginx/sites-enabled/default && sudo wget https://raw.githubusercontent.com/TANGLEBAY/tutorials/master/de/bee-node/nginx.template -O /etc/nginx/sites-enabled/default```

# Nginx Konfiguration bearbeiten
```sudo nano /etc/nginx/sites-enabled/default```

# Htpasswd anlegen
```sudo htpasswd -c /etc/nginx/.htpasswd```

# Nginx neustarten
```sudo systemctl restart nginx```