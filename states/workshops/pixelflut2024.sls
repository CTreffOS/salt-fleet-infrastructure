pixelflut:
    git.latest:
        - name: https://github.com/CTreffOS/ctreffos-pixelflut.git
        - target: /home/user/pixelflut
        - user: user
        - force_reset: True

{% if "pixelflut" in pillar %}
/home/user/pixelflut/server_ip.txt:
    file.managed:
        - user: user
        - group: user
        - mode: 444
        - contents: {{ pillar["pixelflut"]["server_ip"] }}
{% endif %}
