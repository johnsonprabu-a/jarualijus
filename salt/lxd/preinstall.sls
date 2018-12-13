# Generating Bridge for LXD containers #

push_base_script:
  file.managed:
    - name: /opt/base
    - source: salt://lxd/files/base
    - user: root
    - group: root
    - mode: 500
gather_ip_port:
  cmd.run:
    - name: "bash /opt/base"
    - require:
      - file: push_base_script

configuring_br0:
  file.managed:
    - name: /etc/network/interfaces
    - source: salt://lxd/files/interfaces
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - cmd: gather_ip_port
