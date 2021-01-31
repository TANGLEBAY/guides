Hier findet ihr nun eine Auflistung aller genutzten Befehle des Videos zur Einrichtung einer Chrysalis2 Testnode.

**1. Benutzer anlegen**
```
sudo useradd -s /bin/bash -m hornet
```

**2. Pakete installieren**
```
apt install build-essential git snapd -y
```

**3. GO installieren**
```
snap install go --classic
```

**4. Hornet repository clonen**
```
git clone https://github.com/gohornet/hornet.git /var/lib/hornet
```

**5. In das Hornet Verzechnis wechseln**
```
cd /var/lib/hornet
```

**6. Branch wechseln**
```
git checkout develop
```

**7. Hornet-Datei builden**
```
go build -o hornet
```

**8. Dateireche ändern**
```
chown -R hornet:hornet /var/lib/hornet
```

**9. Hornet Service erstellen**
```
nano /lib/systemd/system/hornet.service
```

**10. Servicekonfiguration kopieren**
```
[Unit]
Description=Hornet
Wants=network-online.target
After=network-online.target

[Service]
EnvironmentFile=-/etc/default/hornet
LimitNOFILE=4096
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=hornet
PrivateDevices=yes
PrivateTmp=yes
ProtectSystem=full
ProtectHome=yes

User=hornet
Group=hornet
WorkingDirectory=/var/lib/hornet
TimeoutSec=1200
Restart=always
ExecStart=/var/lib/hornet $OPTIONS

[Install]
WantedBy=multi-user.target
```

**11. System Daemon neu laden**
```
systemctl daemon-reload
```

**12. Hornet Service aktivieren**
```
systemctl enable hornet
```

**13. Peering.json öffnen**
```
nano peering.json
```

**14. Nachbarn in der Peering.json eintragen**
```
{
  "p2p": {
    "peers": [
        "/dns/chrysalis.tanglebay.net/tcp/15600/p2p/12D3KooWD3PgXqsoKCYYuRdWB71EYEX17mv9HQ1BB2PaDns16UWE"
    ],
    "peerAliases": [
        "TANGLEBAY-Testnode"
    ]
  }
}
```

**15. (OPTIONAL) Dashboard erreichbar machen**
```
nano config_chrysalis_testnet.json
```

**16. (OPTIONAL) bindAddress für das Dashboard ändern**
```
  "dashboard": {
    "bindAddress": "0.0.0.0:8081",
    "dev": false,
    "basicAuth": {
      "enabled": false,
      "userName": "",
      "passwordHash": "",
      "passwordSalt": ""
    }
  },
```

**17. Start-konfigurationsdatei für Hornet erzeugen**
```
nano /etc/defaults/hornet
```

**18. Inhalt in die Start-konfigurationsdatei festlegen**
```
OPTIONS="--config config_chrysalis_testnet.json"
```

**19. Hornet starten**
```
systemctl start hornet
```

**20. Log anschauen**
```
journalctl -fu hornet
```

**21. Dashboard aufrufen**
```
http://EURE-SERVER-IP-ODER-DOMAIN:8081
```

