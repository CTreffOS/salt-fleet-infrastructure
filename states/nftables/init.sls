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
