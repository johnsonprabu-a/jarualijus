base:
  '*':
    - common
  'roles:dnsmasq':
    - match: pillar
    - dnsmasq
  'roles:lxd':
    - match: pillar
    - lxd
