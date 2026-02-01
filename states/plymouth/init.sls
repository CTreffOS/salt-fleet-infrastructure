plymouth:
    pkg.installed: []
    cmd.wait:
        - name: plymouth-set-default-theme -R spinner
        - require:
            - pkg: plymouth
            - pkg: plymouth-themes
        - watch:
            - pkg: plymouth-themes

plymouth-themes:
    pkg.installed: []

# enable plymouth, which is disabled by default
/etc/default/grub:
    file.line:
        - mode: replace
        - match: "^GRUB_CMDLINE_LINUX_DEFAULT=.+"
        - content: GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"

/usr/share/plymouth/themes/spinner/header-image.png:
    file.managed:
        - source: salt://plymouth/files/header.png
        - template: jinja
        - require:
            - pkg: plymouth-themes

# required to get the image properly shown upon bootup, which uses the initramfs instead
update-initramfs -k all -u:
    cmd.wait:
        - watch:
            - file: /usr/share/plymouth/themes/spinner/header-image.png

update-grub:
    cmd.wait:
        - watch:
            - file: /etc/default/grub
            - file: /usr/share/plymouth/themes/spinner/header-image.png
