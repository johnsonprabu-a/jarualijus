#install_lxd:
#  cmd.run:
#    - name: "apt install -t xenial-backports lxd lxd-client -y"
#
#installing_suppor_swares:
#  pkg.installed:
#    - names:
#      - zfsutils-linux
#      - bridge-utils


{% if 0 == salt['cmd.retcode']('test -f /var/lib/lxd/server.crt') %}
alert:
  cmd.run:
    - name: "echo 'This host is already part of cluster'"
{% else %}  
pushing_config_file:
  file.managed:
    - name: /opt/cluster_config_primary
    - source: salt://lxd/files/cluster_config_primary
    - user: root
    - group: root
    - mode: 500
{% endif %}
