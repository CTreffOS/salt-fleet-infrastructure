base:
    '*':
        - salt.minion
        - wireguard
    
    'ctreffos*':
        - packagekit
        - fwupd
        - flatpak
