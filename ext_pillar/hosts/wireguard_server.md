# function
## server
* creates a private key under /etc/wireguard/wg-server.key
* creates a config in /etc/wireguard/wg-server.conf and activates it
* creates a "ip-lease" file under /etc/wireguard/wg-salt-hosts.txt listing all known clients (line-number+1 is the assigned ip)
  * once a client-id is added, it cannot be removed to avoid ip conflicts
* mines the public key as wireguard_vpn_server:id
* mines the public key as wireguard_vpn_server:server
* mines the config data as wireguard_vpn_server:endpoint (host:port)
* mines the ip-lease file as wireguard_vpn_server:hosts
* mines the ip-lease file as wireguard_vpn_server:subnet
## clients (ALL other than the server)
* creates a private key under /etc/wireguard/wg-salt-ID.key
* creates a config in /etc/wireguard/wg-salt-ID.conf and activates it
* mines the public key as wireguard_vpn_server:ID:client
* creates a private key under /etc/wireguard/wg-salt-ID.psk
* mines the pre-shared-key as wireguard_vpn_server:ID:psk
### cleanup
* each client mines all known /etc/wireguard/wg-salt-*.conf files and may receives file.absent states to remove obsolete configs

# notes
* server initialization procedure
  * server creates its private key, config
  * mines configuration data to "publish" it (as other nodes cannot access its pillar data and needs the servers public key anyways)
    * id
    * endpoint
    * subnet
    * generated: public key
    * generated: (empty) hosts file
* adoption procedure
  * clients will retrieve the public keys from the mine of all servers
  * roll a new private key with psk and mine it for publishing
  * server will retrieve the public key and psk from the mine of the client
  * server will add the client to the hosts file and add the peer to its config
  * client will then get the hosts file and derive its ip, now creating its interface+peer using the public key, psk, endpoint and assigned ip
* check known peers in your system:
  * salt-call mine.get '*' "wireguard_vpn_server:server"
  * salt-call mine.get '*' "wireguard_vpn_server:ID:client"
