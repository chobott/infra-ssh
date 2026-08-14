# Best Practices pro sprá¹¡vu SSH klí¹¡è¹¥

## 1. Generoví¹¡ní¹¡ silnì½½ch klí¹¡è¹¥

- **Typ klí¹¡è¹¡e:** Ed25519 (preferová¹¡no) nebo RSA 4096-bit
- **Passphrase:** Vždy používejte silnou passphrase (min. 12 znaků)
- **Uniká¹¡tní¹¡ klí¹¡è¹¡e:** Každì½½ uživatel musí́ mí́t vlastnì½½ klí¹¡è¹¡

## 2. Bezpeè¹¡è¹¡né¹¡ uloženì½½ privá¹¡tní¹¡ch klí¹¡è¹¥

- Nikdy neuklá¹¡dejte privá¹¡tní¹¡ klí¹¡è¹¡e do cloudovì½½ch složek (Dropbox, Google Drive)
- Používejte SSH agent nebo hardware tokeny (YubiKey)
- Zálohujte šifrovanì½½

## 3. Oprá¹¡vnì½½ní¹¡ souborů

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
chmod 600 ~/.ssh/authorized_keys
```

## 4. Omezenì½½ pØ®í¹¡stupu

- Používejte `from=` a `command=` restrikce v `authorized_keys`
- PØ®í¹¡klad:
```
from="192.168.1.0/24",no-port-forwarding,no-X11-forwarding ssh-ed25519 AAAA... user@firma.cz
```

## 5. Zaká¹¡zá¹¡ní¹¡ password autentizace

Po nasazení¹¡ všech klí¹¡è¹¥:

```bash
# V /etc/ssh/sshd_config
PasswordAuthentication no
PermitEmptyPasswords no
```

## 6. Použití¹¡ bastion hostu

Pro pØ®í¹¡stup do interní¹¡ sí́tì½½:

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

## 7. Monitoroví¹¡ní¹¡ a logoví¹¡ní¹¡

- Povolte verbose logging: `LogLevel VERBOSE` v `sshd_config`
- Forwardujte logy do SIEM
- Pravidelnì½½ kontrolujte `/var/log/auth.log` nebo `/var/log/secure`

## 8. Dvoufaktorová¹¡ autentizace (2FA)

Pro kritickou infrastrukturu kombinujte SSH klí¹¡è¹¡e s TOTP nebo hardware tokeny.

## 9. Inventarizace klí¹¡è¹¥

Udržujte centrá¹¡lní¹¡ registr všech SSH klí¹¡è¹¥:

| ID | Uživatel | Typ | Úè¹¡el | Expirace | Servery |
|----|----------|-----|------|----------|---------|
| 001 | jan.novak | Ed25519 | Admin | 2027-01 | web01, db01 |
| 002 | deploy | RSA 4096 | CI/CD | 2026-12 | all |

## 10. Okamžitá¹¡ revokace

PØ®i odchodu zamì½½stnance nebo kompromitaci:

1. Odstraňte klí¹¡è¹¡ ze všech `authorized_keys`
2. Zakažte uživatelskì½½ úè¹¡et
3. Zkontrolujte logy pro podezØ®elou aktivitu
4. Vygenerujte novì½½ klí¹¡è¹¡ pro náhradu
