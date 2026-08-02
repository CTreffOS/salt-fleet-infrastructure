# Remove dvd-repository remains
/etc/apt/sources.list:
    file.absent: []

/etc/apt/sources.list.d/debian.sources:
    file.managed:
        - source: salt://apt/files/debian.sources
        - template: jinja

apt-get update:
    cmd.wait:
        - watch:
            - file: /etc/apt/sources.list.d/debian.sources
