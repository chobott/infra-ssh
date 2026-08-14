# Best Practices pro spravu SSH klicu

## 1. Generovani silnych klicu

- **Typ klice:** Ed25519 (preferovano) nebo RSA 4096-bit
- **Passphrase:** Vzdy pouzivejte silnou passphrase (min. 12 znaku)
- **Unikatni klice:** Kazdy uzivatel musi mit vlastni klic

## 2. Bezpecne ulozeni privatnich klicu

- Nikdy neukladejte privatni klice do cloudovych slozek (Dropbox, Google Drive)
- Pouzivejte SSH agent nebo hardware tokeny (YubiKey)
- Zalohujte sifrovane

## 3. Opravneni souboru

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
chmod 600 ~/.ssh/authorized_keys
```

## 4. Omezeni pristupu

- Pouzivejte `from=` a `command=` restrikce v `authorized_keys`
- Priklad:
```
from="192.168.1.0/24",no-port-forwarding,no-X11-forwarding ssh-ed25519 AAAA... user@firma.cz
```

## 5. Zakazani password autentizace

Po nasazeni vsech klicu:

```bash
# V /etc/ssh/sshd_config
PasswordAuthentication no
PermitEmptyPasswords no
```

## 6. Pouziti bastion hostu

Pro pristup do interni site:

```bash
# ~/.ssh/config
Host bastion
    HostName bastion.firma.cz
    User admin
    IdentityFile ~/.ssh/id_ed25519_bastion

Host internal-*
    ProxyJump bastion
    User admin
    IdentityFile ~/.ssh/id_ed25519_internal
```

## 7. Monitorovani a logovani

- Povolte verbose logging: `LogLevel VERBOSE` v `sshd_config`
- Forwardujte logy do SIEM
- Pravidelne kontrolujte `/var/log/auth.log` nebo `/var/log/secure`

## 8. Dvoufaktorova autentizace (2FA)

Pro kritickou infrastrukturu kombinujte SSH klice s TOTP nebo hardware tokeny.

## 9. Inventarizace klicu

Udrzujte centralni registr vsech SSH klicu:

| ID | Uzivatel | Typ | Ucel | Expirace | Servery |
|----|----------|-----|------|----------|---------|
| 001 | jan.novak | Ed25519 | Admin | 2027-01 | web01, db01 |
| 002 | deploy | RSA 4096 | CI/CD | 2026-12 | all |

## 10. Okamzita revokace

Pri odchodu zamestnance nebo kompromitaci:

1. Odstrante klic ze vsech `authorized_keys`
2. Zakazte uzivatelsky ucet
3. Zkontrolujte logy pro podezrelou aktivitu
4. Vygenerujte novy klic pro nahradu
