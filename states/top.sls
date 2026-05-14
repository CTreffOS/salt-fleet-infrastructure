base:
    '*': # careful, on the laptops only the module "systemd_repart" will enlarge the rootfs - we start with ~450MB left!
        - apt
        - salt.minion
        - wireguard
        - base
        - motd
        - ssh

    'knox*':
        - nftables
        - salt.master
    
    'ctreffos*':
        - systemd_repart # as early as possible, as otherwise following stuff may run into no-space-left issues!
        - users
        - base.wifi
        - base.desktop
        - packagekit
        - fwupd
        - flatpak
        - plymouth
        - ssh.auth
        - ssh.no_root
        - avahi
        - timeshift
        - keyboard
        - network_manager
        - vscodium
        - localsend
        - workshops.pixelflut2024
        - workshops.surfschein2025
