#!/bin/bash
# deploy-key.sh – Automatizované¹¹ nasazení¹¹ SSH klí¹¡è¹¡e

set -e

if [ $# -lt 2 ]; then
    echo "Použití¹¡: $0 <public_key_file> <user@host> [user@host ...]"
    exit 1
fi

PUBKEY="$1"
shift

if [ ! -f "$PUBKEY" ]; then
    echo "Chyba: Soubor $PUBKEY neexistuje"
    exit 1
fi

for target in "$@"; do
    echo "=== Nasazení¹¡ na $target ==="
    
    # VytvoØ®ení¹¡ .ssh adresá¹¡Ø®e
    ssh "$target" "mkdir -p ~/.ssh && chmod 700 ~/.ssh"
    
    # PØ®idá¹¡ní¹¡ klí¹¡è¹¡e
    cat "$PUBKEY" | ssh "$target" "cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
    
    echo "✓ Nasazeno na $target"
done

echo "Hotovo!"
