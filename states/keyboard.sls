keyboard_set_layout:
    file.line:
        - name: /etc/default/keyboard
        - match: "XKBLAYOUT=.+"
        - content: "XKBLAYOUT=\"{{ pillar.get("keyboard", {}).get("layout", "de") }}\""
        - mode: replace
        - watch_in:
            - cmd: reapply_layout

keyboard_set_variant:
    file.line:
        - name: /etc/default/keyboard
        - match: "XKBVARIANT=.+"
        # e2 moves the missing </>/|-keys to ALT+GR+2/3/^
        - content: "XKBVARIANT=\"{{ pillar.get("keyboard", {}).get("variant", "e2") }}\""
        - mode: replace
        - watch_in:
            - cmd: reapply_layout

reapply_layout:
    cmd.wait:
        - name: "gsettings set org.gnome.desktop.input-sources sources \"[('xkb', '{{ pillar.get("keyboard", {}).get("layout", "de") }}{% if pillar.get("keyboard", {}).get("variant", "e2") %}+{{ pillar.get("keyboard", {}).get("variant", "e2") }}{% endif %}')]\""
        - runas: user
