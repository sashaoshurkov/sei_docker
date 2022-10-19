# Description
Sei Network — the first orderbook-specific blockchain. This Dockerfile and image is built as part of the testnet run by the Sei team - Act 2. Our team's validator node participates in the testnet with the "freez_art" moniker. If you have any questions, you can contact us on Discord: freez_art#8294

# Install utils
```bash
apt update && apt install -y curl jq wget
```

# Install Docker
```bash
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
```

# Set SEI version (see watch the announcement of updates in Discord. Example: 1.2.2beta)
```bash
echo 'export sei_version=1.2.2beta' >> $HOME/.bash_profile; \
source $HOME/.bash_profile
```

# Initialize the validator with a moniker name (Example moniker_name: solid-sei-rock)
```bash
docker run --rm --name sei_init --network host -v $HOME/.sei:/root/.sei sashaoshurkov/sei:$sei_version seid init [moniker_name] --chain-id atlantic-1
```

# Add a new wallet address, store seeds and buy SEI to it (Example wallet_name: solid-sei-rock)
```bash
docker run --rm -it --name sei_init --network host -v $HOME/.sei:/root/.sei sashaoshurkov/sei:$sei_version seid keys add [wallet_name]
```

# Download genesis and adrrbook
```bash
wget -O $HOME/.sei/config/genesis.json "https://raw.githubusercontent.com/sei-protocol/testnet/master/sei-incentivized-testnet/genesis.json"; \
wget -O $HOME/.sei/config/addrbook.json "https://raw.githubusercontent.com/sei-protocol/testnet/master/sei-incentivized-testnet/addrbook.json"
```

# Set up node configuration
```bash
sed -i "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025usei\"/;" $HOME/.sei/config/app.toml; \
external_address=$(wget -qO- eth0.me); \
sed -i "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.sei/config/config.toml; \
persistent_peers="e3b5da4caea7370cd85d7738eedaec8f56c5be28@144.76.224.246:36656,a37d65086e78865929ccb7388146fb93664223f7@18.144.13.149:26656,8ff4bd654d7b892f33af5a30ada7d8239d6f467b@91.223.3.190:51656,c4e8c9b1005fe6459a922f232dd9988f93c71222@65.108.227.133:26656"; \
sed -i "s/^persistent_peers *=.*/persistent_peers = \"$persistent_peers\"/" $HOME/.sei/config/config.toml
```

# Start SEI Validator
```bash
docker run -d --name sei_node --restart always --network host -v $HOME/.sei:/root/.sei sashaoshurkov/sei:$sei_version
```

# After buying uSEI, stake it to become a validator
```bash
tendermint=$(docker exec -it sei_node seid tendermint show-validator); \
docker exec -it sei_node seid tx staking create-validator --from [wallet_name] --moniker [moniker_name] --pubkey $(echo $tendermint) --chain-id atlantic-1 --amount 900000usei --commission-max-change-rate 0.1 --commission-max-rate 0.2 --commission-rate 0.05 --min-self-delegation 1 --fees 5000usei -y
```

# Get out of jail
```bash
docker exec -it sei_node seid tx slashing unjail --from [wallet_name] --chain-id atlantic-1
```