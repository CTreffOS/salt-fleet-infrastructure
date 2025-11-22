# unattended-upgrades did not work with offline-installing updates - meaning on reboot
# - hang on user-prompts for changed configs
# - requires inhibit-blocker, which causes "freezing" on logouts
# - deadlock with restarting services on reboot
# - by default just did not run properly on shutdown (and during runtime we do not want this!)

unattended-upgrades:
    pkg.removed: []

/etc/apt/apt.conf.d/20auto-upgrades:
    file.absent: []

/etc/apt/apt.conf.d/52unattended-upgrades-local:
    file.absent: []

/etc/systemd/logind.conf.d/unattended-upgrades.conf:
    file.absent: []

/etc/systemd/system/unattended-upgrades-v2.service:
    file.absent: []

# instead let the daily task do a bit of cleanups
/etc/apt/apt.conf.d/20auto-tasks:
    file.managed:
        - source: salt://packagekit/files/20auto-tasks
        - template: jinja

# instead use packagekit offline-updates (which reboots the system into a installing-updates mode instead)
packagekit:
    pkg.installed: []

/etc/systemd/system/trigger-packagekit-offline.service:
    file.absent: []

/etc/systemd/system/trigger-packagekit-offline.timer:
    file.absent: []

/etc/systemd/system/packagekit-trigger-offline.service:
    file.managed:
        - source: salt://packagekit/files/packagekit-trigger-offline.service
        - template: jinja

/etc/systemd/system/packagekit-trigger-offline.timer:
    service.running:
        - name: packagekit-trigger-offline.timer
        - enable: True
        - require:
            - file: /etc/systemd/system/packagekit-trigger-offline.timer
        - watch:
            - file: /etc/systemd/system/packagekit-trigger-offline.timer
    file.managed:
        - source: salt://packagekit/files/packagekit-trigger-offline.timer
        - template: jinja
