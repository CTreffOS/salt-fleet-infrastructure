bash-completion:
    pkg.installed: []

# DE
task-gnome-desktop:
    pkg.installed: []
task-german-desktop:
    pkg.installed: []
gdm3: # start as soon as possible after boot
    service.running:
        - enable: True
        - require: # do not watch, otherwise it will restart on updates as well
            - pkg: task-gnome-desktop

# userspace
imagemagick:
    pkg.installed: []
gimp:
    pkg.installed: []

# development
build-essential:
    pkg.installed: []
cmake:
    pkg.installed: []
cargo:
    pkg.installed: []
brltty: # this one caputes all serial devices (like ESPs or Arduino) as well
    pkg.removed: []
