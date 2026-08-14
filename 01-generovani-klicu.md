# Generoví¹¡ní¹¹ SSH klí¹¡è¹¥

## Doporuè¹¡enì½½ typ klí¹¡è¹¡e

Pro novou infrastrukturu používejte **Ed25519** – je rychlejší a bezpeè¹¡nì½½jší než RSA.

```bash
# Generoví¹¡ní¹¹ Ed25519 klí¹¡è¹¡e
ssh-keygen -t ed25519 -C "vas.email@firma.cz" -f ~/.ssh/id_ed25519_infra
```

Pro kompatibilitu se staršími zaØ®í¹¡zení¹¡mi (nì½½které¹¡ Cisco IOS verze) použijte RSA 4096-bit:

```bash
# Generoví¹¡ní¹¹ RSA 4096-bit klí¹¡è¹¡e
ssh-keygen -t rsa -b 4096 -C "vas.email@firma.cz" -f ~/.ssh/id_rsa_infra
```

## Nastavení¹¹ oprá¹¡vnì½½ní¹¡

Sprá¹¡vná¹¡ oprá¹¡vnì½½ní¹¡ jsou kritická¹¡ pro bezpeè¹¡è¹¡nost:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519_infra
chmod 644 ~/.ssh/id_ed25519_infra.pub
```

## PØ®idá¹¡ní¹¹ klí¹¡è¹¡e do SSH agenta

```bash
# Spuštì½½ní¹¡ agenta
eval "$(ssh-agent -s)"

# PØ®idá¹¡ní¹¹ klí¹¡è¹¡e
ssh-add ~/.ssh/id_ed25519_infra
```

## Kontrola veØ®ejné¹¡ho klí¹¡è¹¡e

```bash
cat ~/.ssh/id_ed25519_infra.pub
```

Vì½½stup bude vypadat napØ®.:
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... vas.email@firma.cz
```

Tento ØØ®á¹¡dek zkopí¹¡rujte do `authorized_keys` na cílovì½½ch zaØ®í¹¡zení¹¡ch.
