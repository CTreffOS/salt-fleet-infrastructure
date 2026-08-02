nftables:
    pkg.installed: []
    service.running:
        - enable: true

/etc/nftables.conf:
    file.managed:
        - source: salt://nftables/files/nftables.conf
        - template: jinja
        - mode: "0444"
        - watch_in:
            - service: nftables
{% if 'wireguard_server' in pillar %}
        - watch:
            # as nft uses iif with only works for existing interfaces, we need to react accordingly if the config is re-rendered
            - cmd: /etc/wireguard/wg-server.conf
{% endif %}
