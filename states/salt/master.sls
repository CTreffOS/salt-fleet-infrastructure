/etc/salt/master.d/reactor.conf:
    file.managed:
        - source: salt://salt/files/reactor.conf

salt-master:
    service.running:
        - enable: True
        - watch:
            - file: /etc/salt/master.d/reactor.conf
