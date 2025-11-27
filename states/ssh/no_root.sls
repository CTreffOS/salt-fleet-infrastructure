/etc/ssh/sshd_config.d/91-salt.conf:
    file.managed:
        - source: salt://ssh/files/91-salt.conf
        - mode: "0444"
        - watch_in:
            - service: openssh-server
