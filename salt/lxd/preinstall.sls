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

backup_existing_config:
  cmd.run:
    - name: "cp -av /etc/network/interfaces /opt/"

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

lets_reboot:
  cmd.run:
    - name: "Kindly verify network configuration and reboot the machine"
