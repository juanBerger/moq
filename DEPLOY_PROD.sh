#!/bin/bash

# Exit on any error
set -e

echo "Starting deployment process..."

# Navigate to project directory
cd ~/moq

# Ensure we're on main branch
git checkout main

# Pull latest changes
echo "Pulling latest changes..."
git pull

# Build release version
echo "Building release version..."
cargo build --release --bin moq-relay

# Strip the binary to make it smaller
echo "Stripping the binary..."
strip target/release/moq-relay

# Stop the service
echo "Stopping pl-moq service..."
sudo systemctl stop pl-moq.service

# Copy executable to /opt/pl-moq
echo "Copying executable to /opt/pl-moq..."
sudo cp target/release/moq-relay /opt/pl-moq/

# Clean up the large target directory to save disk space
echo "Cleaning up build artifacts..."
cargo clean

# Set appropriate permissions
echo "Setting permissions..."
sudo chown -R ubuntu:ubuntu /opt/pl-moq/moq-relay
sudo chmod +x /opt/pl-moq/moq-relay

# Restart the service
echo "Restarting pl-moq service..."
sudo systemctl restart pl-moq.service

echo "Deployment completed successfully!"
