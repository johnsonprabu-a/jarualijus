{% if 'server' in grains['id'] %}
consul_service_file:
  file.managed:
    - name: /etc/systemd/system/consul.service
    - source: salt://consul/files/consul.service.server
    - user: root
    - group: root
    - mode: 755
    - template: jinja
{% elif 'node' in grains['id'] %}
consul_service_file:
  file.managed:
    - name: /etc/systemd/system/consul.service
    - source: salt://consul/files/consul.service.agent
    - user: root
    - group: root
    - mode: 755
    - template: jinja

{% endif %}

Service_check_restart:
  service.running:
    - name: consul.service
    - enable: True
    - full_restart: True
    - watch:
      - file: consul_service_file
