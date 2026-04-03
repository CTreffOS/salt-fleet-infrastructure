/etc/apt/sources.list.d/non-free.sources:
    file.managed:
        - source: salt://base/files/non-free.sources
        - template: jinja

apt-get update:
    cmd.wait:
        - watch:
            - file: /etc/apt/sources.list.d/non-free.sources

firmware-linux-nonfree:
    pkg.installed:
        - require:
            - cmd: apt-get update

firmware-iwlwifi: # our Lenovo T470s have some Intel cards needing this firmware
    pkg.installed:
        - require:
            - cmd: apt-get update
        - watch_in:
            - cmd: update-initramfs -k all -c

modprobe -r iwlwifi && modprobe iwlwifi:
    cmd.wait:
        - watch:
            - pkg: firmware-iwlwifi

NetworkManager-wait-online: # really, this is a bad idea
    service.disabled: []
