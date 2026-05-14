/usr/share/applications/surfschein.desktop:
    file.managed:
        - source: salt://workshops/files/surfschein.desktop
        - mode: "0444"
