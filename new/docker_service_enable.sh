#!/bin/bash

echo "Starting Docker service..."
sudo systemctl enable docker.service
sudo systemctl start docker.service

echo "Adding current user to docker group..."
sudo usermod -aG docker $USER

echo "Docker service status:"
sudo systemctl status docker.service