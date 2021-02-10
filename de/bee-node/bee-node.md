**Befehlsübersicht zur Einrichtung einer Bee Node**

Video-Anleitung: https://www.youtube.com/watch?v=ZgPuhUTPeiw

**1. Benutzer bee erstellen**
```
sudo useradd -s /bin/bash -m bee
```

**2. Pakete installieren**
```
sudo apt install git npm build-essential cmake pkg-config librocksdb-dev llvm clang libclang-dev libssl-dev apache2-utils software-properties-common certbot python3-certbot-nginx -y
```

**3. Repo klonen**
```
sudo git clone https://github.com/iotaledger/bee.git --branch chrysalis-pt-2 /var/lib/bee
```

**4. In das Verzeichnis wechseln**
```
cd /var/lib/bee/bee-node
```

**5. Berechtigungen setzen**
```
sudo chown -R bee:bee /var/lib/bee
```

**6. Benutzer wechseln**
```
sudo su bee
```

**7. Rust installieren**
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh && source $HOME/.cargo/env
```

**8. Git submodule initalisieren**
```
git submodule update --init
```

**9. In das Verzeichnis des Dashboards wechseln**
```
cd /var/lib/bee/bee-node/src/plugins/dashboard/frontend
```

**10. Module instalieren**
```
npm install
```

**11. Build-bee ausführen**
```
npm run build-bee
```

**12. Wieder zurück in das Verzeichnis wechseln**
```
cd /var/lib/bee/bee-node
```

**13. Bee builden**
```
cargo build --release --features dashboard
```

**14. Config kopieren**
```
cp config.example.toml /var/lib/bee/target/release/config.toml
```

**15. In das erstelle Bee Verzeicnis wechseln**
```
cd /var/lib/bee/target/release
```

**16. Identität generieren**
```
./bee p2p-identity
```

**17. P2P private key kopiere und in config.toml einfügen & Nachbarn hinzufügen**
```
nano config.toml
```

**18. Bee-User verlassen**
`STRG+D` oder `exit` ins Terminal

**19. Servicedatei kopieren**
```
sudo wget https://raw.githubusercontent.com/TANGLEBAY/tutorials/master/de/bee-node/bee.service -O /lib/systemd/system/bee.service
```

**20. Daemon neu laden**
```
sudo systemctl daemon-reload
```

**21. Bee Service aktivieren**
```
sudo systemctl enable bee
```

**22. Bee starten**
```
sudo systemctl start bee
```

**23. SSL Zertifikat beantragen (wichtig Port 80 öffnen!)**
```
sudo certbot --nginx -d node.meinedomain.de
```

**24. Nginx Konfiguration ersetzen**
```
sudo rm -rf /etc/nginx/sites-enabled/default && sudo wget https://raw.githubusercontent.com/TANGLEBAY/tutorials/master/de/bee-node/nginx.template -O /etc/nginx/sites-enabled/default
```

**25. Nginx Konfiguration bearbeiten**
```
sudo nano /etc/nginx/sites-enabled/default
```

**26. Htpasswd anlegen**
```
sudo htpasswd -c /etc/nginx/.htpasswd
```

**27. Nginx neustarten**
```
sudo systemctl restart nginx
```
