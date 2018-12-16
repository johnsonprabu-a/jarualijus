## Fingerprint uses sha256

{% set lxd_launch = pillar.get('lxd_launch') %}

pushing_containers:
  file.managed:
    - name: /opt/{{ lxd_launch.image_name }}
    - source: salt://{{ lxd_launch.image_name }}
    - user: root
    - group: root
    - mode: 0755

import_container:
  cmd.run:
    - name: "lxc image import /opt/{{ lxd_launch.image_name }} --alias {{ lxd_launch.alias }}"
    - require:
      - file: pushing_containers

