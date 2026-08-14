# Sprava SSH klicu na Cisco zarizenich

## Pozadavky

- Cisco IOS 15.0+ nebo IOS-XE
- AAA s lokalni databazi nebo TACACS+/RADIUS
- Povoleny SSH server

## Konfigurace SSH serveru

```cisco
! Generovani RSA klice pro server
crypto key generate rsa modulus 2048

! Povoleni SSH
ip ssh version 2
ip ssh server algorithm mac hmac-sha2-512 hmac-sha2-256
ip ssh server algorithm encryption aes256-ctr aes192-ctr aes128-ctr

! AAA konfigurace
aaa new-model
aaa authentication login default local
aaa authorization exec default local
aaa authorization commands 15 default local

! Lokalni uzivatel s SSH pristupem
username admin privilege 15 secret 0 VaseHeslo123

! Omezeni pristupu
line vty 0 15
 transport input ssh
 login authentication default
 access-class SSH-ACCESS in

! ACL pro SSH pristup
ip access-list standard SSH-ACCESS
 permit 192.168.1.0 0.0.0.255
 deny any
```

## Nasazeni verejneho klice uzivatele

### IOS 15.6+ a IOS-XE (podpora SSH klicu)

```cisco
! Vytvoreni uzivatele s SSH klicem
username admin ssh ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ... vas.email@firma.cz

! Nebo pro vice klicu
username admin key-chain SSH-KEYS
```

### Starsi verze (bez prime podpory)

Na starsich Cisco IOS verzich neni prima podpora pro SSH public key authentication. V tomto pripade:

1. Pouzijte silne heslo s AAA/TACACS+
2. Omezte pristup pres ACL
3. Pouzijte bastion host s SSH klici

## Testovani pripojeni

```bash
ssh -i ~/.ssh/id_rsa_infra admin@192.168.1.1
```

## Kontrola SSH relaci

```cisco
show ssh
show ip ssh
```

## Bezpecnostni doporuceni pro Cisco

- Pouzivejte **SSH verze 2** vyhradne
- Zakazat Telnet: `no ip telnet server`
- Omezit VTY pristup na management VLAN
- Pravidelne mente hesla (pokud nepouzivate klice)
- Logujte SSH pristup na syslog server
