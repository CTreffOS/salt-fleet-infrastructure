/usr/share/applications/surfschein.desktop:
    file.managed:
        - source: salt://workshop/files/surfschein.desktop
        - mode: "0444"
