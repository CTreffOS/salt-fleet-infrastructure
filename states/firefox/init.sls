firefox-esr:
    pkg.installed: []

/etc/firefox:
    file.directory: []

/etc/firefox/policies:
    file.directory:
        - require:
            - file: /etc/firefox

/etc/firefox/policies/policies.json:
    file.managed:
        - source: salt://firefox/files/policies.json
        - mode: "0444"
        - require:
            - file: /etc/firefox/policies
