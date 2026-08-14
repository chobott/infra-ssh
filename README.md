# Infra-SSH - Kompletni navod na spravu SSH klicu

Komplexni pruvodce spravou SSH klicu pro administraci Linux serveru, Cisco zarizeni, MikroTik routeru a dalsi infrastruktury.

## Obsah

1. [Generovani SSH klicu](01-generovani-klicu.md)
2. [Linux servery](02-linux-servery.md)
3. [Cisco zarizeni](03-cisco-zarizeni.md)
4. [MikroTik RouterOS](04-mikrotik.md)
5. [Best Practices](05-best-practices.md)
6. [Rotace a audit klicu](06-rotace-a-audit.md)

## Skripty

- `scripts/deploy-key.sh` - Automatizovane nasazeni verejneho klice
- `scripts/audit-keys.sh` - Audit opravnenych klicu na serverech
- `scripts/rotate-key.sh` - Rotace SSH klicu

## Sablony

- `templates/authorized_keys.template` - Sablona pro soubor authorized_keys
- `templates/ssh-config.template` - Sablona SSH configu pro klienta

## Bezpecnostni doporuceni

- Pouzivejte **Ed25519** klice (nebo RSA 4096-bit)
- Vzdy chranite privatni klic **passphrase**
- Rotujte klice kazdych **6-12 mesicu**
- Nikdy nesdilejte privatni klice mezi uzivateli
- Po odchodu zamestnance okamzite zruste jeho klice

## Podpora

V pripade problemu kontaktujte bezpecnostni tym.
