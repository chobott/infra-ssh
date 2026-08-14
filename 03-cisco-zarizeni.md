# Sprá¹¡va SSH klí¹¡è¹¥ na Cisco zaØ®í¹¡zení¹¡ch

## Požadavky

- Cisco IOS 15.0+ nebo IOS-XE
- AAA s loká¹¡lní¹¡ databá¹¡zí¹¡ nebo TACACS+/RADIUS
- Povolenì½½ SSH server

## Konfigurace SSH serveru

```cisco
! Generoví¹¡ní¹¹ RSA klí¹¡è¹¡e pro server
crypto key generate rsa modulus 2048

! Povolení¹¹ SSH
ip ssh version 2
ip ssh server algorithm mac hmac-sha2-512 hmac-sha2-256
ip ssh server algorithm encryption aes256-ctr aes192-ctr aes128-ctr

! AAA konfigurace
aaa new-model
aaa authentication login default local
aaa authorization exec default local
aaa authorization commands 15 default local

! Loká¹¡lní¹¡ uživatel s SSH pØ®í¹¡stupem
username admin privilege 15 secret 0 VaseHeslo123

! Omezenì½½ pØ®í¹¡stupu
line vty 0 15
 transport input ssh
 login authentication default
 access-class SSH-ACCESS in

! ACL pro SSH pØ®í¹¡stup
ip access-list standard SSH-ACCESS
 permit 192.168.1.0 0.0.0.255
 deny any
```

## Nasazení¹¹ veØ®ejné¹¡ho klí¹¡è¹¡e uživatele

### IOS 15.6+ a IOS-XE (podpora SSH klí¹¡è¹¥)

```cisco
! VytvoØ®ení¹¡ uživatele s SSH klí¹¡è¹¡em
username admin ssh ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ... vas.email@firma.cz

! Nebo pro ví́ce klí¹¡è¹¥
username admin key-chain SSH-KEYS
```

### Starší verze (bez pØ®í¹¡mé¹¡ podpory)

Na starší́ch Cisco IOS verzí¹¡ch nenì½½ pØ®í¹¡má¹¡ podpora pro SSH public key authentication. V tomto pØ®í¹¡padì½½:

1. Použijte silné¹¡ heslo s AAA/TACACS+
2. Omezte pØ®í¹¡stup pØ®es ACL
3. Použijte bastion host s SSH klí¹¡è¹¡i

## Testoví¹¡ní¹¹ pØ®ipojenì½½

```bash
ssh -i ~/.ssh/id_rsa_infra admin@192.168.1.1
```

## Kontrola SSH relací¹¡

```cisco
show ssh
show ip ssh
```

## Bezpeè¹¡è¹¡nostní¹¡ doporuè¹¡ení¹¡ pro Cisco

- Používejte **SSH verze 2** vì/yhradnì½½
- Zaká¹¡zat Telnet: `no ip telnet server`
- Omezit VTY pØ®í¹¡stup na management VLAN
- Pravidelnì½½ mìõ¹¡¥te hesla (pokud nepouží́vá¹¡te klí¹¡è¹¡e)
- Logujte SSH pØ®í¹¡stup na syslog server
