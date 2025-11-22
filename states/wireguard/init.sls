wireguard:
    pkg.installed: []
wireguard-tools:
    pkg.installed: []

{% if True %} # LEGACY
generate_wireguard_genkey:
    cmd.run:
        - name: /usr/bin/wg genkey > /etc/wireguard/key.secret
        - creates: /etc/wireguard/key.secret
generate_wireguard_genpsk:
    cmd.run:
        - name: /usr/bin/wg genpsk > /etc/wireguard/psk.secret
        - creates: /etc/wireguard/psk.secret

/etc/salt/minion.d/mine_wireguard.conf:
    file.managed:
        - template: jinja
        - source: salt://salt/files/mine_wireguard.conf
        - watch_in:
            - service: salt-minion
{% endif %}

# server mode (+ cleanup)
{% if 'wireguard_server' in pillar %}
# create its private key
/etc/wireguard/wg-server.key:
    cmd.run:
        - name: /usr/bin/wg genkey > /etc/wireguard/wg-server.key
        - creates: /etc/wireguard/wg-server.key
        - watch_in:
            - module: /etc/wireguard/wg-server.key
    module.wait:
        - mine.send:
            - name: "wireguard_vpn_server:server"
            - mine_function: cmd.run
            - cmd: "cat /etc/wireguard/wg-server.key | wg pubkey"
            - python_shell: True
# write the template config (without its private key)
/etc/wireguard/wg-server.template.conf:
    file.managed:
        - template: jinja
        - source: salt://wireguard/files/server.conf
        - requires:
            - cmd: /etc/wireguard/wg-server.key
        - watch_in:
            - cmd: /etc/wireguard/wg-server.conf
# update the real config / service including the private key
/etc/wireguard/wg-server.conf:
    cmd.wait:
        - name: sed "s:INJECT_PRIVATE_KEY_HERE:$(cat /etc/wireguard/wg-server.key | tr -d '\n'):g" /etc/wireguard/wg-server.template.conf > /etc/wireguard/wg-server.conf
        - watch_in:
            - service: /etc/wireguard/wg-server.conf
            # also trigger mine update only when key changes
            - module: wireguard_mine_id
            - module: wireguard_mine_endpoint
            - module: wireguard_mine_subnet
    service.running:
        - name: wg-quick@wg-server
        - enable: True
# make sure the hosts file for the server is present (even if empty)
{% for node in salt['mine.get']('*', 'wireguard_vpn_server:' + pillar["wireguard_server"]["id"] + ':client') %}{% if node != grains["id"] %}
wireguard_host_{{ node }}:
    file.append:
        - name: /etc/wireguard/wg-server-hosts.txt
        - text: {{ node }}
        - watch_in:
            - module: /etc/wireguard/wg-server-hosts.txt
{% endif %}{% endfor %}
/etc/wireguard/wg-server-hosts.txt:
    file.managed:
        - replace: False
        - watch_in:
            - module: /etc/wireguard/wg-server-hosts.txt
    module.wait:
        - mine.send:
            - name: "wireguard_vpn_server:hosts"
            - mine_function: cmd.run
            - cmd: "cat /etc/wireguard/wg-server-hosts.txt"
wireguard_mine_id:
    module.wait:
        - mine.send:
            - name: "wireguard_vpn_server:id"
            - mine_function: cmd.run
            - cmd: "echo '{{ pillar["wireguard_server"]["id"] }}'"
wireguard_mine_subnet:
    module.wait:
        - mine.send:
            - name: "wireguard_vpn_server:subnet"
            - mine_function: cmd.run
            - cmd: "echo '{{ pillar["wireguard_server"]["subnet"] }}'"
wireguard_mine_endpoint:
    module.wait:
        - mine.send:
            - name: "wireguard_vpn_server:endpoint"
            - mine_function: cmd.run
            - cmd: 'echo {{ pillar["wireguard_server"]["host"] }}:{{ pillar["wireguard_server"]["port"] }}'
{% else %}
/etc/wireguard/wg-server.key:
    file.absent:
        - watch_in:
            {% for key in ['id', 'server', 'endpoint', 'hosts', 'subnet'] %}
            - module: wireguard_mine_{{ key }}
            {% endfor %}
/etc/wireguard/wg-server.template.conf:
    file.absent: []
/etc/wireguard/wg-server.conf:
    file.absent: []
    service.dead:
        - name: wg-quick@wg-server
        - enable: False
{% for key in ['id', 'server', 'endpoint', 'hosts', 'subnet'] %}
wireguard_mine_{{ key }}:
    module.wait:
        - mine.delete:
            - name: "wireguard_vpn_server:{{ key }}"
{% endfor %}
{% endif %}

# client mode
{% for server_node_id, instance_server_public_key in salt['mine.get']('*', 'wireguard_vpn_server:server') | dictsort() %}
{% if server_node_id.strip() != grains["id"] %}
{% set instance_id = salt['mine.get'](server_node_id, 'wireguard_vpn_server:id').get(server_node_id) %}
{% set instance_endpoint = salt['mine.get'](server_node_id, 'wireguard_vpn_server:endpoint').get(server_node_id) %}
{% set instance_hosts = salt['mine.get'](server_node_id, 'wireguard_vpn_server:hosts').get(server_node_id) %}
{% set instance_subnet = salt['mine.get'](server_node_id, 'wireguard_vpn_server:subnet').get(server_node_id) %}

{% set instance_address_ns = namespace(found=None) %}      
{% for line in instance_hosts.split('\n') %}{% if line.strip() == grains["id"] %}
{% set instance_address_ns.found = instance_subnet.format(loop.index + 1) %}
{% endif %}{% endfor %}

# create its private key
/etc/wireguard/wg-salt-{{ instance_id }}.key:
    cmd.run:
        - name: /usr/bin/wg genkey > /etc/wireguard/wg-salt-{{ instance_id }}.key
        - creates: /etc/wireguard/wg-salt-{{ instance_id }}.key
        - watch_in:
            - module: /etc/wireguard/wg-salt-{{ instance_id }}.key
    module.wait:
        - mine.send:
            - name: "wireguard_vpn_server:{{ instance_id }}:client"
            - mine_function: cmd.run
            - cmd: "cat /etc/wireguard/wg-salt-{{ instance_id }}.key | wg pubkey"
            - python_shell: True

# create psk for this server
/etc/wireguard/wg-salt-{{ instance_id }}.psk:
    cmd.run:
        - name: /usr/bin/wg genpsk > /etc/wireguard/wg-salt-{{ instance_id }}.psk
        - creates: /etc/wireguard/wg-salt-{{ instance_id }}.psk
        - watch_in:
            - module: /etc/wireguard/wg-salt-{{ instance_id }}.psk
    module.wait:
        - mine.send:
            - name: "wireguard_vpn_server:{{ instance_id }}:psk"
            - mine_function: cmd.run
            - cmd: "cat /etc/wireguard/wg-salt-{{ instance_id }}.psk"

{% if instance_address_ns.found is defined %}
/etc/wireguard/wg-salt-{{ instance_id }}.template.conf:
    file.managed:
        - template: jinja
        - source: salt://wireguard/files/client.conf
        - context:
            instance_id: "{{ instance_id | trim() }}"
            address: "{{ instance_address_ns.found | trim() }}"
            peer_key: "{{ instance_server_public_key | trim() }}"
            peer_ip: "{{ instance_subnet.format(1) | trim() }}"
            peer_endpoint: "{{ instance_endpoint | trim() }}"
        - watch_in:
            - cmd: /etc/wireguard/wg-salt-{{ instance_id }}.conf

/etc/wireguard/wg-salt-{{ instance_id }}.conf:
    cmd.wait:
        - name: sed "s:INJECT_PRIVATE_KEY_HERE:$(cat /etc/wireguard/wg-salt-{{ instance_id }}.key | tr -d '\n'):g" /etc/wireguard/wg-salt-{{ instance_id }}.template.conf > /etc/wireguard/wg-salt-{{ instance_id }}.conf
        - watch_in:
            - service: /etc/wireguard/wg-salt-{{ instance_id }}.conf
    service.running:
        - name: wg-quick@wg-salt-{{ instance_id }}
        - enable: True
{% endif %}

{% endif %}
{% endfor %}
