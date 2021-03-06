## Usage: state.apply lxd pillar="{'host_type':'primary', 'node':'node1'}"

{% set host_type = pillar.get('host_type') %}
{% set server_name = pillar.get('node') %}


install_lxd:
  cmd.run:
    - name: "apt install -t xenial-backports lxd lxd-client -y"

installing_suppor_swares:
  pkg.installed:
    - names:
      - zfsutils-linux
      - bridge-utils


{% if 0 == salt['cmd.retcode']('test -f /var/lib/lxd/server.crt') %}
alert:
  cmd.run:
    - name: "echo 'This host is already part of cluster'"
{% else %}  
pushing_config_file:
  file.managed:
    - name: /opt/cluster_config_{{ host_type }}
    - source: salt://lxd/files/cluster_config_{{ host_type }}
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - context: {
        node: {{ server_name }}
    }
{% endif %}

configure_cluster:
  cmd.run:
    - name: "cat /opt/cluster_config_{{ host_type }} | lxd init --preseed"
    - require:
      - cmd: install_lxd
      - pkg: installing_suppor_swares
      - file: pushing_config_file

{% if host_type == 'primary' %}
notify_user:
  cmd.run:
    - name: "echo 'Kindy take the backup of the primary server crt file located on /var/lib/lxd/server.crt and attach into the cluster_config_secondary file'"
{% endif %}
