# Ref: https://www.digitalocean.com/community/tutorials/how-to-configure-consul-in-a-production-environment-on-ubuntu-14-04

user_addition:
  group.present:
    - name: consul
  user.present:
    - name: consul
    - createhome: false
    - system: true
    - shell: /sbin/nologin
    - groups:
      - consul
    - require:
      - group: consul

{% for i in "bootstrap", "server", "client" %}
/etc/consul.d/{{ i }}:
  file.directory:
    - user: consul
    - group: consul
    - mode: 755
    - makedirs: True
    - recurse:
        - user
        - group
        - mode
{% endfor %}

/var/consul:
  file.directory:
    - user: consul
    - group: consul
    - makedirs: True
    - mode: 755


install_unzip:
  pkg.installed:
    - name: unzip


transfer_binary:
  file.managed:
    - name: /opt/consul_1.4.2_linux_amd64.zip
    - source: salt://consul/consul_1.4.2_linux_amd64.zip
    - source_hash: sha256=ecdddbc87e7f882c3f9d94e8449865fde553e6f443234a1787414fdacef7af55
    - user: root
    - group: root
    - mode: 755
    - require:
      - pkg: install_unzip
    - unless: '[ -f /opt/consul_1.4.2_linux_amd64.zip ] && echo "Yes"'


extract_binary:
  cmd.run:
    - name: "unzip /opt/consul_1.4.2_linux_amd64.zip -d /opt/"
    - unless: '[ -f /opt/consul ] && echo "Yes"'
    - watch:
      - file: transfer_binary

moving_ext_binary:
  file.managed:
    - name: /usr/local/bin/consul
    - source: /opt/consul
    - user: root
    - group: root
    - mode: 555
    - force: true
    - watch:
      - cmd: extract_binary
    - unless: '[ -f /usr/local/bin/consul ] && echo "Yes"'

