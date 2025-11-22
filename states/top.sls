base:
    '*':
        - wireguard
        - salt.minion

    'knox*':
        - salt.vpn_server

    'ctreffos*':
        - salt.vpn_client
