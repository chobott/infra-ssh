# Generovani SSH klicu

## Doporuceny typ klice

Pro novou infrastrukturu pouzivejte **Ed25519** - je rychlejsi a bezpecnejsi nez RSA.

```bash
# Generovani Ed25519 klice
ssh-keygen -t ed25519 -C "vas.email@firma.cz" -f ~/.ssh/id_ed25519_infra
```

Pro kompatibilitu se starsimi zarizenimi (nektere Cisco IOS verze) pouzijte RSA 4096-bit:

```bash
# Generovani RSA 4096-bit klice
ssh-keygen -t rsa -b 4096 -C "vas.email@firma.cz" -f ~/.ssh/id_rsa_infra
```

## Nastaveni opravneni

Spravna opravneni jsou kriticka pro bezpecnost:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519_infra
chmod 644 ~/.ssh/id_ed25519_infra.pub
```

## Pridani klice do SSH agenta

```bash
# Spusteni agenta
eval "$(ssh-agent -s)"

# Pridani klice
ssh-add ~/.ssh/id_ed25519_infra
```

## Kontrola verejneho klice

```bash
cat ~/.ssh/id_ed25519_infra.pub
```

Vystup bude vypadat napr.:
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... vas.email@firma.cz
```

Tento radek zkopirujte do `authorized_keys` na cilovych zarizenich.
