#!/usr/bin/env bash
set -e

echo "[*] Session 02: hardening started"

# Phase 1: Secure the local Vault and its secrets
chmod 700 "$HOME/Vault"
chmod 600 "$HOME/Vault/secrets.txt"

# Phase 2: Secure the system identity file (/etc/shadow)
sudo chmod 640 /etc/shadow
sudo chown root:shadow /etc/shadow

echo "[*] Hardening complete."