/etc/wireguard/wg-salt.template.conf:
    file.managed:
        - template: jinja
        - source: salt://salt/files/server.conf
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

# make sure we have a line in file for known public key to have a stable ordering/ip-set for the peers
{% for node in salt['mine.get']('*', 'mine_wireguard_pub') %}{% if node != grains["id"] %}
note_{{ node }}:
    file.append:
        - name: /etc/wireguard/wg-salt-hosts.txt
        - text: {{ node }}
        - watch_in:
            - cmd: forced_mine_update
{% endif %}{% endfor %}

forced_mine_update:
    cmd.wait:
        - name: salt-call mine.update
