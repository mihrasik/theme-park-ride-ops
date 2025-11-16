#!/bin/bash
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo systemctl status docker.service