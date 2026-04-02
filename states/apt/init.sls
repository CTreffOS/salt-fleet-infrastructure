# Remove dvd-repository remains
/etc/apt/sources.list:
{% if salt['file.file_exists']('/etc/apt/sources.list') %}
    file.line:
        - match: "^(deb cdrom:.+)"
        - mode: delete
        - create: False
{% else %}
    file.absent: [] # if not existing, keep it that way...
{% endif %}
