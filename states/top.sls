base:
    '*':
        - apt
        - salt.minion
        - wireguard
        - base
        - motd
        - ssh

    'knox*':
        - nftables
    
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
