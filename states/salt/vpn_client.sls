/etc/wireguard/wg-salt.template.conf:
    file.managed:
        - template: jinja
        - source: salt://salt/files/client.conf
        - watch_in:
            - cmd: /etc/wireguard/wg-salt.conf

/etc/wireguard/wg-salt.conf:
    cmd.wait:
        - name: sed "s:INJECT_PRIVATE_KEY_HERE:$(cat /etc/wireguard/key.secret | tr -d '\n'):g" /etc/wireguard/wg-salt.template.conf > /etc/wireguard/wg-salt.conf
        - watch_in:
            - service: /etc/wireguard/wg-salt.conf
    service.running:
        - name: wg-quick@wg-salt
        - enable: True
