/usr/lib/repart.d:
  file.directory: []

/usr/lib/repart.d/50-root.conf: # configure repart to grow the root-partition (the /etc variant is NOT supported under Debian)
    file.managed:
        - source: salt://systemd_repart/files/50-root.conf
        - require:
            - file: /usr/lib/repart.d

systemd-repart: # needed to update the partition table, so systemd-growfs can work
    pkg.installed:
        - require:
            - file: /usr/lib/repart.d/50-root.conf
    service.running:
        - watch: # only start if the service was just installed (otherwise done on next reboot, bad if SALT starts NOW)
            - pkg: systemd-repart
        - require:
            - pkg: systemd-repart

systemd-growfs-root.service:
    service.running:
        - watch:
            - pkg: systemd-repart # only start if the service if systemd-repart was just installed
            - service: systemd-repart # ...or ran explicitly
        - require:
            - service: systemd-repart
