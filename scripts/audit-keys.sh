#!/bin/bash
# audit-keys.sh - Audit SSH klicu na serverech

set -e

# Seznam serveru (upravte dle potreby)
SERVERS=(
    "admin@web01.firma.cz"
    "admin@web02.firma.cz"
    "admin@db01.firma.cz"
    "admin@fw01.firma.cz"
)

echo "=== SSH Key Audit Report ==="
echo "Datum: $(date)"
echo ""

for server in "${SERVERS[@]}"; do
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Server: $server"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Ziskani vsech authorized_keys
    ssh "$server" "
        echo '=== Uzivatele s SSH pristupem ==='
        for user_dir in /home/*; do
            if [ -f \$user_dir/.ssh/authorized_keys ]; then
                user=\$(basename \$user_dir)
                count=\$(wc -l < \$user_dir/.ssh/authorized_keys)
                echo \"  \$user: \$count klicu\"
            fi
        done
        
        echo ''
        echo '=== Typy klicu ==='
        cat /home/*/\.ssh/authorized_keys 2>/dev/null | \
        awk '{print \$1}' | sort | uniq -c | sort -rn
        
        echo ''
        echo '=== Stare klice (>90 dnu) ==='
        find /home -name 'id_*.pub' -mtime +90 2>/dev/null || echo 'Zadne stare klice'
    " 2>/dev/null || echo "⚠ Nepodarilo se pripojit k $server"
    
    echo ""
done

echo "=== Konec auditu ==="
