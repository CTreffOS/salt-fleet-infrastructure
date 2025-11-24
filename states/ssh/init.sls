/etc/ssh/sshd_config.d/90-salt.conf:
    file.managed:
        - source: salt://ssh/files/90-salt.conf
        - mode: "0444"
        - watch_in:
            - service: openssh-server

openssh-server:
    service.running:
        - name: ssh
        - enable: true

fail2ban:
    pkg.installed: []
