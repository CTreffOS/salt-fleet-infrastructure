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
    
    'ctreffos*':
        - users
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
        - workshops.pixelflut2024
