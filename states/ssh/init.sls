task-ssh-server: # debian speciality
    pkg.installed: []

/etc/ssh/sshd_config.d/90-salt.conf:
    file.managed:
        - source: salt://ssh/files/90-salt.conf
        - mode: "0444"
        - watch_in:
            - service: openssh-server
        - require:
            - pkg: task-ssh-server

openssh-server:
    service.running:
        - name: ssh
        - enable: true
        - require:
            - pkg: task-ssh-server

fail2ban:
    pkg.installed:
        - require:
            - pkg: task-ssh-server
