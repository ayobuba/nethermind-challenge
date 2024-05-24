# Nethermind and Teku Setup Guide

This guide will help you set up and run Teku with Nethermind using Docker. Follow the steps below to get started.

## Prerequisites

Ensure you have the following installed:
- Docker
- Docker Compose
- OpenSSL (for generating the JWT secret)

## Step 1: Create Project Directory

Create a directory for your project and navigate into it.

```bash
mkdir nethermind-teku-setup && cd nethermind-teku-setup
```

## Step 2: Generate JWT Secret

Generate a JWT secret that will be used by both Teku and Nethermind.

```bash
openssl rand -hex 32 | tr -d "\n" > jwtsecret
```

## Step 3: Create 'nethermind.config.json' File

Create the nethermind.config.json file with the following content:

```json
{
  "Init": {
    "Network": "holesky"
  },
  "Logging": {
    "File": {
      "Name": "/data/logs/nethermind.log",
      "Level": "info"
    }
  },
  "Sync": {
    "FastSync": true,
    "PivotBlockHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "PivotBlockNumber": 0
  },
  "JsonRpc": {
    "Enabled": true,
    "Host": "0.0.0.0",
    "Port": 8545,
    "Modules": ["eth", "net", "web3", "personal", "debug", "txpool"],
    "EngineHost": "0.0.0.0",
    "EnginePort": 8551,
    "EngineApis": ["engine"],
    "WebSocketsEnabled": true,
    "WebSocketsPort": 8546,
    "WebSocketsHost": "0.0.0.0"
  },
  "Database": {
    "Path": "/data",
    "LogsRetentionPeriod": 7,
    "PruningEnabled": true
  },
  "Ethereum": {
    "GenesisBlockHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "ChainId": 1337
  },
  "Discovery": {
    "Enabled": true,
    "Port": 30303,
    "ListenIP": "0.0.0.0"
  },
  "P2P": {
    "Enabled": true,
    "Port": 30303,
    "ExternalIP": "0.0.0.0"
  },
  "Metrics": {
    "Prometheus": {
      "Enabled": true,
      "Port": 9090
    }
  },
  "HealthChecks": {
    "Enabled": true,
    "Prometheus": {
      "Enabled": true,
      "Port": 9090
    }
  },
  "TxPool": {
    "MaxSize": 2048
  },
  "JsonRpc": {
    "Enabled": true,
    "Host": "0.0.0.0",
    "Port": 8545,
    "EnginePort": 8551,
    "JwtSecretFile": "/data/jwtsecret"
  }
}
```
## Step 4: Create Dockerfile.teku

Create a 'Dockerfile.teku' file with the following contents:

```Dockerfile
FROM consensys/teku:latest

USER root

# Create necessary directories with correct permissions
RUN mkdir -p /opt/teku/data/logs && \
    chown -R teku:teku /opt/teku/data

USER teku

ENTRYPOINT ["teku"]
CMD ["--network=holesky", "--data-path=/opt/teku/data", "--eth1-endpoints=http://nethermind:8545", "--metrics-enabled=true", "--metrics-port=8008", "--rest-api-enabled=true", "--rest-api-docs-enabled=true", "--rest-api-interface=0.0.0.0", "--rest-api-port=5051", "--ee-endpoint=http://nethermind:8551", "--ee-jwt-secret-file=/data/jwtsecret"]

```

## Step 5: Create docker-compose.yml

Create a docker-compose.yml file with the following contents:

```yaml
version: '3.8'

services:
  nethermind:
    image: nethermind/nethermind
    container_name: nethermind
    volumes:
      - ./nethermind.config.json:/home/nethermind/.nethermind/config.json
      - ./jwtsecret:/data/jwtsecret
      - nethermind_data:/data
    ports:
      - "8545:8545"   # JSON-RPC port
      - "8546:8546"   # WebSocket port
      - "30303:30303" # P2P port
      - "9090:9090"   # Prometheus metrics
      - "8551:8551"   # Engine JSON-RPC port
    command: -c /home/nethermind/.nethermind/config.json

  teku:
    image: edwards-custom-teku
    container_name: teku
    volumes:
      - ./jwtsecret:/data/jwtsecret
      - teku_data:/opt/teku/data
    ports:
      - "8008:8008"   # Prometheus metrics
      - "5051:5051"   # REST API port

volumes:
  nethermind_data:
  teku_data:

```

## Step 6: Create start_teku.sh Script

Create a start_teku.sh script with the following content.

```bash
#!/bin/bash

# Create directories and set permissions
mkdir -p /opt/teku/data/logs
chown -R teku:teku /opt/teku/data

# Start Teku beacon node
teku \
  --network=holesky \
  --data-path=/opt/teku/data \
  --eth1-endpoints=http://nethermind:8545 \
  --metrics-enabled=true \
  --metrics-port=8008 \
  --rest-api-enabled=true \
  --rest-api-docs-enabled=true \
  --rest-api-interface=0.0.0.0 \
  --rest-api-port=5051

```
```bash
chmod +x start_teku.sh
```

## Step 6: Build Custom Teku Image

Build the custom Teku image using the Dockerfile created earlier.

```bash
docker build -t edwards-custom-teku -f Dockerfile.teku .
```

## Step 7: Start Docker Containers

Build the custom Teku image using the Dockerfile created earlier.

```bash
docker-compose up -d
```

## Step 8: Check Logs

Check the logs of both containers to ensure they are running correctly.

```bash
docker logs nethermind
docker logs teku
```
![Nethermind Screenshot](/images/nethermind.png)
![Teku Screenshot](/images/teku.png)

## Step 9: Verify Available Endpoints

Verify the available endpoints in Teku.

```bash
curl -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://localhost:8545
```
![JSON RPC](/images/jsonrpc.png)


