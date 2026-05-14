localsend:
  cmd.run:
    - name: "flatpak install --noninteractive flathub org.localsend.localsend_app"
    - unless: "flatpak list | grep org.localsend.localsend_app"
