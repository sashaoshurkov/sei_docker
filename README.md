# SEI Blockchain Docker

# Start SEI Blockchain
docker run -d --name sei_node --restart always --network host -v $HOME/.sei:/root/.sei sashaoshurkov/sei:latest
