base:
  '*':
    - common
  'roles:dnsmasq':
    - match: pillar
    - dnsmasq
