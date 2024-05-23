# Ethereum Full-Node Setup on Holesky Testnet

This document details the steps to set up an Ethereum full-node (execution client + consensus client) on the Holesky Testnet using Nethermind and a consensus client of your choice.

## Table of Contents
1. [Introduction](#introduction)
2. [System Requirements](#system-requirements)
3. [Step-by-Step Setup Instructions](#step-by-step-setup-instructions)
    - [Install Dependencies](#install-dependencies)
    - [Run docker-compose](#run-docker-compose)
    - [Configure Nethermind](#configure-nethermind)
    - [Configure Consensus Client](#configure-consensus-client)
4. [Verification Process](#verification-process)
    - [Execution Client API](#execution-client-api)
    - [Consensus Client API](#consensus-client-api)
5. [Logs and Screenshots](#logs-and-screenshots)
6. [Troubleshooting Tips](#troubleshooting-tips)

## Introduction
This guide provides detailed instructions to set up an Ethereum full-node on the Holesky Testnet. The node will consist of the Nethermind execution client and a consensus client of your choice. This setup will help ensure the reliability and correctness of the Ethereum network without a validator client.

## System Requirements
- **Hardware:** Minimum requirements include 4 CPU cores, 8GB RAM, and 500GB of SSD storage.
- **Software:** Docker and Docker Compose installed.

## Step-by-Step Setup Instructions

### Install Dependencies
Ensure Docker and Docker Compose are installed on your system.

### Run docker-compose
Clone the necessary repositories for Nethermind and your chosen consensus client.

```bash
docker-compose up -d