fwupd:
    pkg.installed: []

/etc/systemd/system/fwupd-update.service:
    file.managed:
        - source: salt://fwupd/files/fwupd-update.service
        - template: jinja
/etc/systemd/system/fwupd-update.timer:
    file.managed:
        - source: salt://fwupd/files/fwupd-update.timer
        - template: jinja
        - require:
            - file: /etc/systemd/system/fwupd-update.service
    service.running:
        - name: fwupd-update.timer
        - enable: True
        - require:
            - file: /etc/systemd/system/fwupd-update.timer
        - watch:
            - file: /etc/systemd/system/fwupd-update.timer
