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

