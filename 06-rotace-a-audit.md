# Rotace a audit SSH klí¹¡è¹¥

## Harmonogram rotace

| Typ klí¹¡è¹¡e | Frekvence |
|-----------|-----------|
| Osobní¹¡ klí¹¡è¹¡e | 6–12 mìõ¹¡¥ců |
| Automatizaè¹¡ní¹¡/system klí¹¡è¹¡e | 3–6 mìõ¹¡¥ců |
| Vysoce bezpeè¹¡è¹¡né¹¡ prostØ®edí¹¡ | ÈÙ¡astì½½ji dle politiky |

## Proces rotace klí¹¡è¹¡e

### Krok 1: Vygeneroví¹¡ní¹¡ novè¹¡ho klí¹¡è¹¡e

```bash
ssh-keygen -t ed25519 -C "jan.novak+2026@firma.cz" -f ~/.ssh/id_ed25519_infra_2026
```

### Krok 2: Nasazení¹¡ novè¹¡ho klí¹¡è¹¡e

```bash
# PØ®idejte novì½½ klí¹¡è¹¡ do authorized_keys (zachovejte starì½½ doè¹¡asnì½½)
cat ~/.ssh/id_ed25519_infra_2026.pub >> ~/.ssh/authorized_keys

# Otestujte pØ®ipojenì½½ s novì½½m klí¹¡è¹¡em
ssh -i ~/.ssh/id_ed25519_infra_2026 user@server.cz
```

### Krok 3: Odstranì½½ní¹¡ starè¹¡ho klí¹¡è¹¡e

Po úspì½½šné¹¡m testoví¹¡ní¹¡ odstraňte starì½½ klí¹¡è¹¡ z `authorized_keys`:

```bash
# Editujte authorized_keys a odstraňte ØØ®á¹¡dek se starì½½m klí¹¡è¹¡em
nano ~/.ssh/authorized_keys
```

### Krok 4: Zálohoví¹¡ní¹¡ a zniè¹¡ení¹¡ starè¹¡ho klí¹¡è¹¡e

```bash
# Záloha pØ®ed zniè¹¡ení¹¡m
mv ~/.ssh/id_ed25519_infra ~/.ssh/old_keys/id_ed25519_infra_2025_backup

# Bezpeè¹¡è¹¡né¹¡ smazá¹¡ní¹¡ (pØ®epsá¹¡ní¹¡)
shred -u ~/.ssh/id_ed25519_infra_2025_backup
```

## Audit SSH klí¹¡è¹¥

### Skript pro audit (viz `scripts/audit-keys.sh`)

```bash
#!/bin/bash
# audit-keys.sh

SERVERS=("web01" "web02" "db01" "fw01")

for server in "${SERVERS[@]}"; do
    echo "=== $server ==="
    ssh admin@$server "cat /home/*/\.ssh/authorized_keys" 2>/dev/null | \
    awk '{print $3}' | sort | uniq -c | sort -rn
done
```

### Ruè¹¡ní¹¡ audit

```bash
# Kontrola všech klí¹¡è¹¥ na serveru
find /home -name authorized_keys -exec echo "=== {} ===" \; -exec cat {} \;

# Kontrola starì½½ch klí¹¡è¹¥ (>90 dní́)
find /home -name 'id_rsa.pub' -mtime +90 -exec echo "Rotate key: {}" \;
```

## Checklist pro audit

- [ ] Všechny klí¹¡è¹¡e jsou Ed25519 nebo RSA 4096-bit
- [ ] Žá¹¡dné¹¡ DSA nebo RSA <2048 bit
- [ ] Všechny privá¹¡tní¹¡ klí¹¡è¹¡e mají passphrase
- [ ] Oprá¹¡vnì½½ní¹¡ souborů jsou sprá¹¡vná¹¡ (600/644/700)
- [ ] Žá¹¡dné¹¡ sdí¹¡lené¹¡ klí¹¡è¹¡e mezi uživateli
- [ ] Všichni odchozí¹¡ zamì½½stnanci mají zrušené¹¡ klí¹¡è¹¡e
- [ ] PasswordAuthentication je disabled
- [ ] Logoví¹¡ní¹¡ je povoleno (LogLevel VERBOSE)
- [ ] Fail2Ban nebo podobná¹¡ ochrana je aktivní¹¡

## Automatizace auditu

Pro vìtší́ infrastrukturu použijte:

- **SSH Audit** (ssh-audit.ru)
- **Teleport** (certificate-based SSH)
- **HashiCorp Vault** (SSH secrets engine)
- **Ansible** pro hromadné¹¡ nasazení¹¡ a audit

PØ®í¹¡klad Ansible playbook pro audit:

```yaml
- name: Audit SSH keys
  hosts: all
  tasks:
    - name: Check authorized_keys
      command: cat /home/{{ item }}/.ssh/authorized_keys
      loop: "{{ users }}"
      register: auth_keys

    - name: Report old keys
      find:
        paths: /home
        patterns: "id_rsa.pub"
        age: 90d
      register: old_keys
```
