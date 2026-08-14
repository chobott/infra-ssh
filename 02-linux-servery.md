# Sprava SSH klicu na Linux serverech

## Nasazeni verejneho klice

### Metoda 1: ssh-copy-id (doporuceno)

```bash
ssh-copy-id -i ~/.ssh/id_ed25519_infra.pub user@server.cz
```

### Metoda 2: Rucni kopirovani

```bash
# Na serveru vytvorte .ssh adresar
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Vlozte verejny klic
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... vas.email@firma.cz" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

## Konfigurace SSH serveru

Upravte `/etc/ssh/sshd_config`:

```bash
# Zakazat prihlaseni heslem
PasswordAuthentication no

# Povolit pouze klice
PubkeyAuthentication yes

# Zakazat root login (doporuceno)
PermitRootLogin no

# Zmenit port (volitelne)
Port 2222

# Omezit pristup na konkretne uzivatele
AllowUsers admin sysadmin

# Omezit pristup z konkretnich IP
AllowUsers admin@192.168.1.0/24
```

Restart SSH serveru:

```bash
# Ubuntu/Debian
sudo systemctl restart sshd

# RHEL/CentOS
sudo systemctl restart sshd
```

## Testovani pripojeni

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
