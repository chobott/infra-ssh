# Sprá¹¡va SSH klí¹¡è¹¥ na MikroTik RouterOS

## Požadavky

- RouterOS v7.x (doporuè¹¡eno)
- SSH server povolen

## Povolení¹¹ SSH serveru

```bash
# V WinBox nebo CLI
/system ssh set enabled=yes
```

## Import SSH klí¹¡è¹¡e na MikroTik

MikroTik nepodporuje generoví¹¡ní¹¹ SSH klí¹¡è¹¥ pØ®í¹¡mo na zaØ®í¹¡zení¹¡. Klí¹¡è¹¡ musí́ bý́t vygenerová¹¡n externì½½ (Linux, Windows) a importová¹¡n.

### Krok 1: Vygeneroví¹¡ní¹¹ klí¹¡è¹¡e (na Linuxu)

```bash
ssh-keygen -t rsa -b 2048 -f mikrotik_key -N ""
```

**Pozná¹¡mka:** RouterOS vyžaduje klí¹¡è¹¡ **bez passphrase** pro import.

### Krok 2: Import privá¹¡tní¹¡ho klí¹¡è¹¡e

```bash
# Nahrajte soubor mikrotik_key na MikroTik pØ®es FTP/SCP
# Poté¹¡ importujte:

/system ssh import-host-key private-key-file=mikrotik_key
```

### Krok 3: Nasazení¹¹ veØ®ejné¹¡ho klí¹¡è¹¡e pro uživatele

```bash
# V CLI MikroTiku
/user ssh-keys add user=admin key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ... vas.email@firma.cz"
```

Nebo pØ®es WinBox:
1. Jdì½½te na **System → Users**
2. Vyberte uživatele (napØ®. `admin`)
3. Kliknì½½te na **SSH Keys**
4. PØ®idejte novì½½ klí¹¡è¹¡ a vložte veØ®ejnì½½ klí¹¡è¹¡

## Konfigurace SSH serveru

```bash
# Zmì½½na portu (volitelné¹¡)
/ip service set ssh port=2222

# Povolení¹¹ pouze strong krypto (v7.12+)
/system ssh set strong-crypto=yes

# Omezenì½½ pØ®í¹¡stupu z konkré¹¡tní¹¡ch IP
/ip service set ssh address=192.168.1.0/24
```

## Zaká¹¡zá¹¡ní¹¡ heslové¹¡ho pØ®ihlá¹¡šení́

Po úspì½½šné¹¡m nasazení¹¡ klí¹¡è¹¥:

```bash
# VytvoØ®te záložní¹¡ho uživatele s heslem pro pØ®í¹¡pad nouze
/user add name=backup-admin password=SilneHeslo123 group=full

# Poté¹¡ mùžete omezit ostatní¹¡ uživatele na SSH klí¹¡è¹¡e
/user set admin password=""
```

## Testoví¹¡ní¹¹ pØ®ipojenì½½

```bash
ssh -i ~/.ssh/id_rsa_infra admin@192.168.1.1
```

## Bezpeè¹¡è¹¡nostní¹¡ doporuè¹¡ení¹¡ pro MikroTik

- Používejte **RouterOS v7** s podporou Ed25519 (od v7.12)
- Zaká¹¡zat Telnet a MAC-Telnet pokud nejsou potØ®eba
- Omezit SSH pØ®í¹¡stup na management VLAN
- Pravidelnì½½ aktualizujte RouterOS
- Používejte firewall pro omezenì½½ zdrojovì½½ch IP
- Zakažte unused služby (FTP, WWW pokud nepotØ®ebné¹¡)
