#!/bin/bash
# audit-keys.sh – Audit SSH klí¹¡è¹¥ na serverech

set -e

# Seznam serverů (upravte dle potØ®eby)
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
    
    # Zí¹¡ská¹¡ní¹¡ všech authorized_keys
    ssh "$server" "
        echo '=== Uživatelé¹¡ s SSH pØ®í¹¡stupem ==='
        for user_dir in /home/*; do
            if [ -f \$user_dir/.ssh/authorized_keys ]; then
                user=\$(basename \$user_dir)
                count=\$(wc -l < \$user_dir/.ssh/authorized_keys)
                echo \"  \$user: \$count klí¹¡è¹¥ů\"
            fi
        done
        
        echo ''
        echo '=== Typy klí¹¡è¹¥ů ==='
        cat /home/*/\.ssh/authorized_keys 2>/dev/null | \
        awk '{print \$1}' | sort | uniq -c | sort -rn
        
        echo ''
        echo '=== Staré¹¡ klí¹¡è¹¡e (>90 dní́) ==='
        find /home -name 'id_*.pub' -mtime +90 2>/dev/null || echo 'Žá¹¡dné¹¡ staré¹¡ klí¹¡è¹¡e'
    " 2>/dev/null || echo "⚠ NepodaØ®ilo se pØ®ipojit k $server"
    
    echo ""
done

echo "=== Konec auditu ==="
