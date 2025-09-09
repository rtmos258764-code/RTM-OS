#!/bin/bash
# Add a public SSH key (piped from stdin) to this machine

mkdir -p ~/.ssh
cat >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
echo "[SSH] ✅ Phone key added to authorized_keys"
