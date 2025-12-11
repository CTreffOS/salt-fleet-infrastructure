vscodium:
  cmd.run:
    - name: "flatpak install --noninteractive flathub com.vscodium.codium"
    - unless: "flatpak list | grep com.vscodium.codium"

dbus-daemon:
    pkg.installed: []

{% for extension in ["ms-python.python", "alefragnani.bookmarks", "rust-lang.rust-analyzer"] %}
vscodium-{{ extension }}:
  cmd.run:
    - name: "dbus-run-session flatpak run com.vscodium.codium --install-extension {{ extension }}"
    - unless: "dbus-run-session flatpak run com.vscodium.codium --list-extensions | grep {{ extension }}"
    - runas: user
    - require:
        - pkg: dbus-daemon
{% endfor %}
