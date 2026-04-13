root:
  user.present:
    - fullname: Administrator
    - usergroup: true
    - password: "$5$HmBMWtalrwI5Ccfn$lBRLE051k7EgyLGwGaVQq2w9rqabXHvTDrkDB09Qdo5" # mkpasswd -m sha-256
user:
  user.present:
    - fullname: Chaos User
    - shell: /bin/bash
    - usergroup: true
    - password: "$5$6zW8IygtZH7uAqPa$tZMIB3WlCnBgrH73nZdz3NQBscdwU5jFlEPuLXZLZP8" # mkpasswd -m sha-256
    - groups:
      - cdrom
      - floppy
      - sudo
      - audio
      - video
      - plugdev
      - users
      - netdev
      - scanner
      - bluetooth
      - lpadmin

# configure user-background
/usr/share/backgrounds/background.jpg:
  file.managed:
    - source: salt://users/files/background.jpg
    - mode: "0444"
user_hide_updates:
  cmd.run:
    - name: "gsettings set org.gnome.software download-updates false"
    - runas: user
    - require:
      - file: /usr/share/backgrounds/background.jpg
    - unless: "gsettings get org.gnome.software download-updates | grep false"
user_set_background:
  cmd.run:
    - name: "gsettings set org.gnome.desktop.background picture-uri file:///usr/share/backgrounds/background.jpg"
    - runas: user
    - require:
      - file: /usr/share/backgrounds/background.jpg
    - unless: "gsettings get org.gnome.desktop.background picture-uri | grep file:///usr/share/backgrounds/background.jpg"
user_set_background_dark:
  cmd.run:
    - name: "gsettings set org.gnome.desktop.background picture-uri-dark file:///usr/share/backgrounds/background.jpg"
    - runas: user
    - require:
      - file: /usr/share/backgrounds/background.jpg
    - unless: "gsettings get org.gnome.desktop.background picture-uri-dark | grep file:///usr/share/backgrounds/background.jpg"
