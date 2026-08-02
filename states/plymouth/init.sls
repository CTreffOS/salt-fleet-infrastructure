plymouth:
    pkg.installed: []

plymouth-themes:
    pkg.installed: []

# enable plymouth, which is disabled by default
/etc/default/grub-splash:
    file.line:
        - mode: replace
        - match: "^GRUB_CMDLINE_LINUX_DEFAULT=.+"
        - content: GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
        - watch_in:
            - cmd: update-grub
# hide countdown
/etc/default/grub-hidden:
    file.line:
        - mode: replace
        - match: "^GRUB_TIMEOUT=.+"
        - content: GRUB_TIMEOUT=0
        - watch_in:
            - cmd: update-grub

/usr/share/plymouth/themes/spinner/header-image.png:
    file.managed:
        - source: salt://plymouth/files/header.png
        - require:
            - pkg: plymouth-themes

plymouth-set-default-theme -R spinner:
    cmd.wait:
        - require:
            - pkg: plymouth
            - pkg: plymouth-themes
        - watch:
            - pkg: plymouth-themes
            - file: /usr/share/plymouth/themes/spinner/header-image.png

# required to get the image properly shown upon bootup, which uses the initramfs instead
update-initramfs -k all -c:
    cmd.wait:
        - watch:
            - file: /usr/share/plymouth/themes/spinner/header-image.png

update-grub:
    cmd.wait:
        - watch:
            - cmd: update-initramfs -k all -c
            - file: /usr/share/plymouth/themes/spinner/header-image.png
