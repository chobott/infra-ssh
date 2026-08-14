# Rotace a audit SSH klicu

## Harmonogram rotace

| Typ klice | Frekvence |
|-----------|-----------|
| Osobni klice | 6-12 mesicu |
| Automatizacni/system klice | 3-6 mesicu |
| Vysoce bezpecne prostredi | Castěji dle politiky |

## Proces rotace klice

### Krok 1: Vygenerovani noveho klice

```bash
ssh-keygen -t ed25519 -C "jan.novak+2026@firma.cz" -f ~/.ssh/id_ed25519_infra_2026
```

### Krok 2: Nasazeni noveho klice

```bash
# Pridejte novy klic do authorized_keys (zachovejte stary docasne)
cat ~/.ssh/id_ed25519_infra_2026.pub >> ~/.ssh/authorized_keys

# Otestujte pripojeni s novym klicem
ssh -i ~/.ssh/id_ed25519_infra_2026 user@server.cz
```

### Krok 3: Odstraneni stareho klice

Po uspesnem testovani odstrante stary klic z `authorized_keys`:

```bash
# Editujte authorized_keys a odstrante radek se starym klicem
nano ~/.ssh/authorized_keys
```

### Krok 4: Zalohovani a zniceni stareho klice

```bash
# Zaloha pred znicenim
mv ~/.ssh/id_ed25519_infra ~/.ssh/old_keys/id_ed25519_infra_2025_backup

# Bezpecne smazani (prepsani)
shred -u ~/.ssh/id_ed25519_infra_2025_backup
```

## Audit SSH klicu

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

### Rucni audit

```bash
# Kontrola vsech klicu na serveru
find /home -name authorized_keys -exec echo "=== {} ===" \; -exec cat {} \;

# Kontrola starych klicu (>90 dnu)
find /home -name 'id_rsa.pub' -mtime +90 -exec echo "Rotate key: {}" \;
```

## Checklist pro audit

- [ ] Vsechny klice jsou Ed25519 nebo RSA 4096-bit
- [ ] Zadné´´ne DSA nebo RSA <2048 bit
- [ ] Vsechny privatni klice maji passphrase
- [ ] Opravneni souboru jsou spravna (600/644/700)
- [ ] Zadné´´ne sdilene klice mezi uzivateli
- [ ] Vsichni odchozi zamestnanci maji zrusene klice
- [ ] PasswordAuthentication je disabled
- [ ] Logovani je povoleno (LogLevel VERBOSE)
- [ ] Fail2Ban nebo podobna ochrana je aktivni

## Automatizace auditu

Pro vetsi infrastrukturu pouzijte:

- **SSH Audit** (ssh-audit.ru)
- **Teleport** (certificate-based SSH)
- **HashiCorp Vault** (SSH secrets engine)
- **Ansible** pro hromadne nasazeni a audit

Priklad Ansible playbook pro audit:

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
