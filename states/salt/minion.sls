salt_apply:
  schedule.absent: [] # due to the wrapping call to systemd.inhibit, this logic was moved into an own systemd-unit

/etc/salt/minion.d/master.conf:
  file.managed:
    - template: jinja
    - source: salt://salt/files/master.conf
    - watch_in:
        - service: salt-minion

/etc/hosts:
  file.append:
    - text: 10.13.37.1 salt-via-wg
    - watch_in:
        - service: salt-minion

/etc/systemd/system/salt-minion.service.d/by-salt.conf:
  file.managed:
    - template: jinja
    - source: salt://salt/files/salt-minion-override.conf
    - mode: "0644"
    - makedirs: True
    - watch_in:
        - service: salt-minion

salt-minion:
  service.running:
    - enable: True

/etc/systemd/system/salt-apply.service:
  file.managed:
    - source: salt://salt/files/salt-apply.service
    - template: jinja

/etc/systemd/system/salt-apply.timer:
  file.managed:
    - source: salt://salt/files/salt-apply.timer
    - template: jinja
    - require:
        - file: /etc/systemd/system/salt-apply.service

salt-apply.timer:
  service.running:
    - enable: True
    - require:
        - file: /etc/systemd/system/salt-apply.service
        - file: /etc/systemd/system/salt-apply.timer
        - service: salt-minion
    - watch:
        - file: /etc/systemd/system/salt-apply.service
        - file: /etc/systemd/system/salt-apply.timer

/usr/local/bin/salt-state:
  file.managed:
    - source: salt://salt/files/salt-state.sh
    - template: jinja
    - mode: "0555"
