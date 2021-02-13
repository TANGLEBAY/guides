# Command list to install a bee node

YouTube: https://www.youtube.com/watch?v=jC1PKj--lpg

## Install bee

**1. Create the user bee**
```
sudo useradd -s /bin/bash -m bee
```

**2. Install packages**
```
sudo apt install git npm build-essential cmake pkg-config librocksdb-dev llvm clang libclang-dev libssl-dev apache2-utils software-properties-common certbot python3-certbot-nginx -y
```

**3. Clone the repository**
```
sudo git clone https://github.com/iotaledger/bee.git --branch chrysalis-pt-2 /var/lib/bee
```

**4. Switch the directory**
```
cd /var/lib/bee/bee-node
```

**5. Set permissions for the user bee**
```
sudo chown -R bee:bee /var/lib/bee
```

**6. Switch user to bee**
```
sudo su bee
```

**7. Install rust**
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh && source $HOME/.cargo/env
```

**8. Initalize the git submodules**
```
git submodule update --init
```

**9. Switch to the dashboard directory**
```
cd /var/lib/bee/bee-node/src/plugins/dashboard/frontend
```

**10. Install the modules for the dashboard**
```
npm install
```

**11. Build the dashboard**
```
npm run build-bee
```

**12. Switch to the bee-node directory**
```
cd /var/lib/bee/bee-node
```

**13. Build bee**
```
cargo build --release --features dashboard
```

**14. Copy the bee config**
```
cp config.example.toml /var/lib/bee/target/release/config.toml
```

**15. Switch the directory**
```
cd /var/lib/bee/target/release
```

**16. Generate a node identity**
```
./bee p2p-identity
```

**17. Edit the bee configuratio to adjust the private key and neighbors**
```
nano config.toml
```

**18. Exit the bee user**
`CTRG+D` oder `exit` ins Terminal

**19. Copy the service file**
```
sudo wget https://raw.githubusercontent.com/TANGLEBAY/tutorials/master/en/bee-node/bee.service -O /lib/systemd/system/bee.service
```

**20. Reload the system daemon**
```
sudo systemctl daemon-reload
```

**21. Enable the bee service**
```
sudo systemctl enable bee
```

**22. Start bee**
```
sudo systemctl start bee
```

**23. Request a ssl certificate via letsencrypt (port 80 needs to be open!))**
```
sudo certbot --nginx -d node.meinedomain.de
```

**24. Replace the nginx default config**
```
sudo rm -rf /etc/nginx/sites-enabled/default && sudo wget https://raw.githubusercontent.com/TANGLEBAY/tutorials/master/en/bee-node/nginx.template -O /etc/nginx/sites-enabled/default
```

**25. Edit the nginx default config**
```
sudo nano /etc/nginx/sites-enabled/default
```

**26. Create htpasswd file**
```
sudo touch /etc/nginx/.htpasswd
```

**27. Create htpasswd file**
```
sudo htpasswd -B /etc/nginx/.htpasswd USERNAME
```

**28. Restart nginx**
```
sudo systemctl restart nginx
```

## Update bee

**1. Stop your bee node**
```
sudo systemctl stop bee
```

**2. Update bee (you need to run this command as user bee (sudo su bee)!)**
```
curl -sL https://raw.githubusercontent.com/TANGLEBAY/tutorials/master/en/bee-node/update-bee.sh | bash -
```

**3. Start your bee node**
```
sudo systemctl start bee
```