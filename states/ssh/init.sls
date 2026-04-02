task-ssh-server: # debian speciality
    pkg.installed: []

/etc/ssh/sshd_config.d: # after setup via PXe this may get wiped to reset the keys
  file.directory:
        - require:
            - pkg: openssh-server
            - pkg: task-ssh-server

/etc/ssh/sshd_config.d/90-salt.conf:
    file.managed:
        - source: salt://ssh/files/90-salt.conf
        - mode: "0444"
        - watch_in:
            - service: openssh-server
        - require:
            - file: /etc/ssh/sshd_config.d

openssh-server:
    pkg.installed: []
    service.running:
        - name: ssh
        - enable: true
        - require:
            - file: /etc/ssh/sshd_config.d/90-salt.conf

fail2ban:
    pkg.installed:
        - require:
            - pkg: openssh-server
