base:
    '*':
        - salt.minion
        - wireguard
    
    'ctreffos*':
        - packagekit
