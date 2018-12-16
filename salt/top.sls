base:
  '*':
    - common
  'roles:dnsmasq':
    - match: pillar
    - dnsmasq
  'roles:lxd':
    - match: pillar
    - lxd
  'roles:lxd_launch':
    - match: pillar
    - lxd_launch
