flatpak:
  pkg.installed: []

xdg-desktop-portal-gtk:
  pkg.installed: []

flatpak-add-flathub:
  cmd.run:
    - name: "flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && touch /.has-flathub"
    - creates:
      - /.has-flathub

{% for flatpak_mode, systemd_target in {"system": "multi-user", "user": "default"}.items() %}
# create systemd units to keep everything updated
/etc/systemd/{{ flatpak_mode }}/flatpak-update.service:
    file.managed:
        - source: salt://flatpak/files/flatpak-update.service
        - template: jinja
        - context:
            flatpak_mode: {{ flatpak_mode }}
/etc/systemd/{{ flatpak_mode }}/flatpak-update.timer:
    file.managed:
        - source: salt://flatpak/files/flatpak-update.timer
        - template: jinja
        - context:
            flatpak_mode: {{ flatpak_mode }}
            systemd_target: {{ systemd_target }}
        - require:
            - file: /etc/systemd/{{ flatpak_mode }}/flatpak-update.service
{% if flatpak_mode == "system" %}
    service.running:
        - name: flatpak-update.timer
        - enable: True
        - require:
            - file: /etc/systemd/{{ flatpak_mode }}/flatpak-update.timer
        - watch:
            - file: /etc/systemd/{{ flatpak_mode }}/flatpak-update.timer
{% else %}
/etc/systemd/{{ flatpak_mode }}/flatpak-update.timer-enable:
    cmd.run:
        - name: systemctl --global enable flatpak-update.timer
        - unless: systemctl --global is-enabled flatpak-update.timer
        - require:
            - file: /etc/systemd/{{ flatpak_mode }}/flatpak-update.service
{% endif %}

# create systemd units to keep everything clean
/etc/systemd/{{ flatpak_mode }}/flatpak-cleanup.service:
    file.managed:
        - source: salt://flatpak/files/flatpak-cleanup.service
        - template: jinja
        - context:
            flatpak_mode: {{ flatpak_mode }}
/etc/systemd/{{ flatpak_mode }}/flatpak-cleanup.timer:
    file.managed:
        - source: salt://flatpak/files/flatpak-cleanup.timer
        - template: jinja
        - context:
            flatpak_mode: {{ flatpak_mode }}
            systemd_target: {{ systemd_target }}
        - require:
            - file: /etc/systemd/{{ flatpak_mode }}/flatpak-cleanup.service
{% if flatpak_mode == "system" %}
    service.running:
        - name: flatpak-cleanup.timer
        - enable: True
        - require:
            - file: /etc/systemd/{{ flatpak_mode }}/flatpak-cleanup.timer
        - watch:
            - file: /etc/systemd/{{ flatpak_mode }}/flatpak-cleanup.timer
{% else %}
/etc/systemd/{{ flatpak_mode }}/flatpak-cleanup.timer-enable:
    cmd.run:
        - name: systemctl --global enable flatpak-cleanup.timer
        - unless: systemctl --global is-enabled flatpak-cleanup.timer
        - require:
            - file: /etc/systemd/{{ flatpak_mode }}/flatpak-cleanup.timer
{% endif %}
{% endfor %}
