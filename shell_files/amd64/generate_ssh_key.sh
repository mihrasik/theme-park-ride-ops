#!/bin/bash
# -t ed25519 – uses the modern Ed25519 algorithm (you can use rsa if you prefer).
# -C – a comment to identify the key.
# -f – the file name for the private key; the public key will be written to the same name wit .pub.
#
# Pick a location that Vagrant can read (e.g. ~/.ssh/vagrant_rsa)
ssh-keygen -t ed25519 -C "vagrant@$(hostname)" -f ~/.ssh/vagrant_rsa
