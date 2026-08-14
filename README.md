# Infra-SSH – Kompletní¹¹ návod na sprá¹¡vu SSH klí¹¡è¹¥

Komplexní¹¹ průvodce správou SSH klí¹¡è¹¥ pro administraci Linux serverů, Cisco zaØ®í¹¡zen, MikroTik routerů a další infrastruktury.

## 📚 Obsah

1. [Generoví¹¡ní¹¹ SSH klí¹¡è¹¥](01-generovani-klicu.md)
2. [Linux servery](02-linux-servery.md)
3. [Cisco zaØ®í¹¡zení¹¡](03-cisco-zarizeni.md)
4. [MikroTik RouterOS](04-mikrotik.md)
5. [Best Practices](05-best-practices.md)
6. [Rotace a audit klí¹¡è¹¥](06-rotace-a-audit.md)

## 🛠️ Skripty

- `scripts/deploy-key.sh` – Automatizované¹¹ nasazení¹¹ veØ®ejné¹¡ho klí¹¡è¹¡e
- `scripts/audit-keys.sh` – Audit oprá¹¡vněné¹¡ch klí¹¡è¹¥ na serverech
- `scripts/rotate-key.sh` – Rotace SSH klí¹¡è¹¥

## 📋 Šablony

- `templates/authorized_keys.template` – Šablona pro soubor authorized_keys
- `templates/ssh-config.template` – Šablona SSH configu pro klienta

## 🔐 Bezpečnostní¹¹ doporučení¹¡

- Používejte **Ed25519** klí¹¡è¹¡e (nebo RSA 4096-bit)
- Vždy chraňte privá¹¡tní¹¹ klí¹¡è¹¡ **passphrase**
- Rotujte klí¹¡è¹¡e každé¹¡ch **6–12 měsí¹¡ců**
- Nikdy nesdí¹¡lejte privá¹¡tní¹¹ klí¹¡è¹¡e mezi uživateli
- Po odchodu zaměstnance okamžitě zrušte jeho klí¹¡è¹¡e

## 📞 Podpora

V případě problémů kontaktujte bezpečnostní¹¹ tým.
