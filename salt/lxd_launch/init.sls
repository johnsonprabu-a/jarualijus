## usage: state.apply lxd_launch.launch_container pillar="{'ip':'last octet of the ip', 'hostname':'custom_name', 'node':'name_of_the_cluster_node"}"
## eg: salt lab1 state.apply lxd_launch pillar="{'ip':'62', 'hostname':'beta', 'node':'node2'}"

{% set lxd_launch = pillar.get('lxd_launch') %}

{% set node = pillar.get("node") %}
{% set ip = pillar.get("ip") %}
{% set hostname = pillar.get("hostname") %}


launch_container:
  cmd.run:
    - name: "lxc launch --target {{ node }} {{ lxd_launch.alias }} {{ hostname }}"
    
push_nw_config:
  file.managed:
    - name: /opt/{{ hostname }}.50-cloud-init.cfg
    - source: salt://lxd_launch/files/interfaces
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context: {
        ip:  {{ ip }}
     }
    - require:
      - cmd: launch_container


pushing_file_to_container:
  cmd.run:
    - name: "lxc file push /opt/{{ hostname }}.50-cloud-init.cfg {{ hostname }}/etc/network/interfaces.d/50-cloud-init.cfg"

push_hosts:
  file.managed:
    - name: /opt/{{ hostname }}.hosts
    - source:  salt://lxd_launch/files/hosts
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context: {
        ip:  {{ ip }},
        hostname: {{ hostname }}
      }
    - require:
      - cmd: launch_container


pushing_host_file_to_container:
  cmd.run:
    - name: "lxc file push /opt/{{ hostname }}.hosts {{ hostname }}/etc/hosts"

replace_minion_id:
  file.managed:
    - name: /opt/{{ hostname }}.minion_id
    - source: salt://lxd_launch/files/minion_id
    - user: root
    - group: root
    - mode: 0644
    - template: jinja
    - context: {
        minion_id: {{ hostname }}
     }
    - require:
      - cmd: launch_container

pushing_minion_id_to_container:
  cmd.run:
    - name: "lxc file push /opt/{{ hostname }}.minion_id {{ hostname }}/etc/salt/minion_id"

restarting_container:
    cmd.run:
    - name: "lxc restart {{ hostname }}"
    - require: 
      - cmd: pushing_file_to_container
      - cmd: pushing_minion_id_to_container
      - cmd: pushing_host_file_to_container

