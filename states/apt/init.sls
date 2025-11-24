# Remove dvd-repository remains
/etc/apt/sources.list:
    file.line:
        - match: "^(deb cdrom:.+)"
        - mode: delete
        - create: False
