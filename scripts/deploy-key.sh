#!/bin/bash
# deploy-key.sh - Automatizovane nasazeni SSH klice

set -e

if [ $# -lt 2 ]; then
    echo "Pouziti: $0 <public_key_file> <user@host> [user@host ...]"
    exit 1
fi

PUBKEY="$1"
shift

if [ ! -f "$PUBKEY" ]; then
    echo "Chyba: Soubor $PUBKEY neexistuje"
    exit 1
fi

for target in "$@"; do
    echo "=== Nasazeni na $target ==="
    
    # Vytvoreni .ssh adresare
    ssh "$target" "mkdir -p ~/.ssh && chmod 700 ~/.ssh"
    
    # Pridani klice
    cat "$PUBKEY" | ssh "$target" "cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
    
    echo "✓ Nasazeno na $target"
done

echo "Hotovo!"
