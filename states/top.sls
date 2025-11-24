base:
    '*':
        - apt
        - salt.minion
        - wireguard
        - base
        - motd
        - ssh
    
    'ctreffos*':
        - users
        - packagekit
        - fwupd
        - flatpak
        - ssh.auth
