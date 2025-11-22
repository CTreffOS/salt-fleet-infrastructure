wireguard:
    pkg.installed: []
wireguard-tools:
    pkg.installed: []

generate_wireguard_genkey:
    cmd.run:
        - name: /usr/bin/wg genkey > /etc/wireguard/key.secret
        - creates: /etc/wireguard/key.secret
generate_wireguard_genpsk:
    cmd.run:
        - name: /usr/bin/wg genpsk > /etc/wireguard/psk.secret
        - creates: /etc/wireguard/psk.secret

/etc/salt/minion.d/mine_wireguard.conf:
    file.managed:
        - template: jinja
        - source: salt://salt/files/mine_wireguard.conf
        - watch_in:
            - service: salt-minion
