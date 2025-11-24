root:
  user.present:
    - fullname: Administrator
    - usergroup: true
    - password: "$5$HmBMWtalrwI5Ccfn$lBRLE051k7EgyLGwGaVQq2w9rqabXHvTDrkDB09Qdo5" # mkpasswd -m sha-256
user:
  user.present:
    - fullname: Chaos User
    - usergroup: true
    - password: "$5$6zW8IygtZH7uAqPa$tZMIB3WlCnBgrH73nZdz3NQBscdwU5jFlEPuLXZLZP8" # mkpasswd -m sha-256
    - groups:
      - cdrom
      - floppy
      - sudo
      - audio
      - video
      - plugdev
      - users
      - netdev
      - scanner
      - bluetooth
      - lpadmin
