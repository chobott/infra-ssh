# Sprá¹¡va SSH klí¹¡è¹¥ na Linux serverech

## Nasazení¹¹ veØ®ejné¹¡ho klí¹¡è¹¡e

### Metoda 1: ssh-copy-id (doporuè¹¡eno)

```bash
ssh-copy-id -i ~/.ssh/id_ed25519_infra.pub user@server.cz
```

### Metoda 2: Ruè¹¡ní¹¡ kopí¹¡rová¹¡ní¹¡

```bash
# Na serveru vytvoØ®te .ssh adresá¹¡Ø®
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# VloØ¾te veØ®ejnì½½ klí¹¡è¹¡
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... vas.email@firma.cz" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

## Konfigurace SSH serveru

Upravte `/etc/ssh/sshd_config`:

```bash
# Zaká¹¡zat pØ®ihlá¹¡šení́ heslem
PasswordAuthentication no

# Povolit pouze klí¹¡è¹¡e
PubkeyAuthentication yes

# Zaká¹¡zat root login (doporuè¹¡eno)
PermitRootLogin no

# Zmì½½nit port (volitelné¹¡)
Port 2222

# Omezit pØ®í¹¡stup na konkré¹¡tní¹¡ uživatele
AllowUsers admin sysadmin

# Omezit pØ®í¹¡stup z konkré¹¡tní¹¡ch IP
AllowUsers admin@192.168.1.0/24
```

Restart SSH serveru:

```bash
# Ubuntu/Debian
sudo systemctl restart sshd

# RHEL/CentOS
sudo systemctl restart sshd
```

## Testoví¹¡ní¹¹ pØ®ipojenì½½

```bash
ssh -i ~/.ssh/id_ed25519_infra user@server.cz
```

## Instalace Fail2Ban (ochrana proti brute-force)

```bash
sudo apt install fail2ban  # Debian/Ubuntu
sudo yum install fail2ban  # RHEL/CentOS

sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

Konfigurace v `/etc/fail2ban/jail.local`:

```ini
[sshd]
enabled = true
port = 22
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
```
