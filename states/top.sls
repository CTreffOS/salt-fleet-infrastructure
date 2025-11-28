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
        - ssh.no_root
        - avahi
        - timeshift
        - keyboard
        - network_manager
