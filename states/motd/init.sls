/etc/update-motd.d/90-salt:
    file.managed:
        - source: salt://motd/files/motd.j2
        - template: jinja
        - mode: "0555"
/etc/motd:
    file.managed:
        - contents: ""
        - mode: "0444"

# remove old message from Ansible
/etc/update-motd.d/90-custom:
    file.absent: []
