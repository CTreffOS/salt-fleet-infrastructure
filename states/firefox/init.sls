/etc/firefox/policies/policies.json:
    file.managed:
        - source: salt://firefox/files/policies.json
        - mode: "0444"
