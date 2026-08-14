#!/bin/bash
# rotate-key.sh - Rotace SSH klice

set -e

if [ $# -lt 2 ]; then
    echo "Pouziti: $0 <old_key_name> <new_key_name>"
    echo "Priklad: $0 id_ed25519_infra id_ed25519_infra_2026"
    exit 1
fi

OLD_KEY="$1"
NEW_KEY="$2"
SERVERS=("admin@web01" "admin@web02" "admin@db01")

echo "=== Rotace SSH klice ==="
echo "Stary klic: ~/.ssh/$OLD_KEY"
echo "Novy klic: ~/.ssh/$NEW_KEY"
echo ""

# Generovani noveho klice pokud neexistuje
if [ ! -f ~/.ssh/$NEW_KEY ]; then
    echo "Generovani noveho klice..."
    ssh-keygen -t ed25519 -C "$(whoami)+$(date +%Y)@firma.cz" -f ~/.ssh/$NEW_KEY
fi

# Nasazeni noveho klice na vsechny servery
for server in "${SERVERS[@]}"; do
    echo "Nasazeni na $server..."
    ssh-copy-id -i ~/.ssh/$NEW_KEY.pub "$server"
done

# Test noveho klice
echo ""
echo "=== Test noveho klice ==="
for server in "${SERVERS[@]}"; do
    echo "Test: $server"
    ssh -i ~/.ssh/$NEW_KEY "$server" "echo '✓ Pripojeni uspesne'" || echo "⚠ Selhalo pripojeni k $server"
done

echo ""
echo "=== Dulezite ==="
echo "1. Po overeni funkcnosti odstrante stary klic z authorized_keys na vsech serverech"
echo "2. Zalohujte a bezpecne znicte stary privatni klic: ~/.ssh/$OLD_KEY"
echo "3. Aktualizujte SSH config pokud pouzivate"
