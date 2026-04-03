salt_apply:
  schedule.present:
    - function: state.apply
    - seconds: 300 # 5 minutes
    - splay: 30
    - run_on_start: False # the master has a reactor installed, which auto-applies the state on minion start, so no need to also trigger it (before)

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

/usr/local/bin/salt-state:
  file.managed:
    - source: salt://salt/files/salt-state.sh
    - template: jinja
    - mode: "0555"
