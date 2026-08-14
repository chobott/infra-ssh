# Sprava SSH klicu na MikroTik RouterOS

## Pozadavky

- RouterOS v7.x (doporuceno)
- SSH server povolen

## Povoleni SSH serveru

```bash
# Ve WinBox nebo CLI
/system ssh set enabled=yes
```

## Import SSH klice na MikroTik

MikroTik nepodporuje generovani SSH klicu primo na zarizeni. Klic musi byt vygenerovan externe (Linux, Windows) a importovan.

### Krok 1: Vygenerovani klice (na Linuxu)

```bash
ssh-keygen -t rsa -b 2048 -f mikrotik_key -N ""
```

**Poznamka:** RouterOS vyzaduje klic **bez passphrase** pro import.

### Krok 2: Import privatniho klice

```bash
# Nahrajte soubor mikrotik_key na MikroTik pres FTP/SCP
# Pote importujte:

/system ssh import-host-key private-key-file=mikrotik_key
```

### Krok 3: Nasazeni verejneho klice pro uzivatele

```bash
# V CLI MikroTiku
/user ssh-keys add user=admin key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ... vas.email@firma.cz"
```

Nebo pres WinBox:
1. Jdete na **System → Users**
2. Vyberte uzivatele (napr. `admin`)
3. Kliknete na **SSH Keys**
4. Pridejte novy klic a vlozte verejny klic

## Konfigurace SSH serveru

```bash
# Zmena portu (volitelne)
/ip service set ssh port=2222

# Povoleni pouze strong krypto (v7.12+)
/system ssh set strong-crypto=yes

# Omezeni pristupu z konkretnich IP
/ip service set ssh address=192.168.1.0/24
```

## Zakazani hesloveho prihlaseni

Po uspesnem nasazeni klicu:

```bash
# Vytvorte zalozniho uzivatele s heslem pro pripad nouze
/user add name=backup-admin password=SilneHeslo123 group=full

# Pote muzete omezit ostatni uzivatele na SSH klice
/user set admin password=""
```

## Testovani pripojeni

```bash
ssh -i ~/.ssh/id_rsa_infra admin@192.168.1.1
```

## Bezpecnostni doporuceni pro MikroTik

- Pouzivejte **RouterOS v7** s podporou Ed25519 (od v7.12)
- Zakazat Telnet a MAC-Telnet pokud nejsou potreba
- Omezit SSH pristup na management VLAN
- Pravidelne aktualizujte RouterOS
- Pouzijte firewall pro omezeni zdrojovych IP
- Zakazte unused sluzby (FTP, WWW pokud nepotrebne)
