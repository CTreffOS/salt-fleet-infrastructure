{% if "wifi_radius_credentials" in pillar %}
/etc/NetworkManager/system-connections/by-salt.nmconnection:
    file.managed:
        - source: salt://network_manager/files/by-salt.nmconnection
        - template: jinja
        - mode: "0400"
        - watch_in:
            - service: NetworkManager

/etc/NetworkManager/system-connections/by-salt.pem:
    file.managed:
        - source: salt://network_manager/files/rabbithole.pem
        - mode: "0400"
        - watch_in:
            - service: NetworkManager
{% endif %}

# remove previous ansible configuration
/etc/NetworkManager/system-connections/by-ansible.nmconnection:
    file.absent: []

NetworkManager:
    service.running:
        - enable: true
