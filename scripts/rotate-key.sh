#!/bin/bash
# rotate-key.sh – Rotace SSH klí¹¡è¹¡e

set -e

if [ $# -lt 2 ]; then
    echo "Použití¹¡: $0 <old_key_name> <new_key_name>"
    echo "PØ®í¹¡klad: $0 id_ed25519_infra id_ed25519_infra_2026"
    exit 1
fi

OLD_KEY="$1"
NEW_KEY="$2"
SERVERS=("admin@web01" "admin@web02" "admin@db01")

echo "=== Rotace SSH klí¹¡è¹¡e ==="
echo "Starì½½ klí¹¡è¹¡: ~/.ssh/$OLD_KEY"
echo "Novì½½ klí¹¡è¹¡: ~/.ssh/$NEW_KEY"
echo ""

# Generoví¹¡ní¹¡ novè¹¡ho klí¹¡è¹¡e pokud neexistuje
if [ ! -f ~/.ssh/$NEW_KEY ]; then
    echo "Generoví¹¡ní¹¡ novè¹¡ho klí¹¡è¹¡e..."
    ssh-keygen -t ed25519 -C "$(whoami)+$(date +%Y)@firma.cz" -f ~/.ssh/$NEW_KEY
fi

# Nasazení¹¡ novè¹¡ho klí¹¡è¹¡e na všechny servery
for server in "${SERVERS[@]}"; do
    echo "Nasazení¹¡ na $server..."
    ssh-copy-id -i ~/.ssh/$NEW_KEY.pub "$server"
done

# Test novè¹¡ho klí¹¡è¹¡e
echo ""
echo "=== Test novè¹¡ho klí¹¡è¹¡e ==="
for server in "${SERVERS[@]}"; do
    echo "Test: $server"
    ssh -i ~/.ssh/$NEW_KEY "$server" "echo '✓ PØ®ipojenì½½ úspì½½šné¹¡'" || echo "⚠ Selhalo pØ®ipojenì½½ k $server"
done

echo ""
echo "=== Důležité ==="
echo "1. Po ovì½½Ø®ení¹¡ funkè¹¡nosti odstraňte starì½½ klí¹¡è¹¡ z authorized_keys na všech serverech"
echo "2. Zálohujte a bezpeè¹¡è¹¡nì½½ zničte starì½½ privá¹¡tní¹¡ klí¹¡è¹¡: ~/.ssh/$OLD_KEY"
echo "3. Aktualizujte SSH config pokud používí¹¡te"
