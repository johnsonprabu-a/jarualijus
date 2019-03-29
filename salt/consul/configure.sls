{% if pillar['bootstrap'] is defined %}
replacing_bootstrap_file:
  file.managed:
    - name: /etc/consul.d/bootstrap/config.json
    - source: salt://consul/files/bootstrap_config.json
    - user: consul
    - group: consul
    - mode: 755
{% endif %}

{% if 'server' in grains['id'] %}
replacing_server_file:
  file.managed:
    - name: /etc/consul.d/server/config.json
    - source: salt://consul/files/server_config.json
    - user: consul
    - group: consul
    - mode: 755

{% for cert in 'consul-agent-ca.pem', 'Test-server-consul-0.pem', 'Test-server-consul-0-key.pem' %}
placing_server_certificates_{{ cert }}:
  file.managed:
    - name: /etc/consul.d/server/{{ cert }}
    - source: salt://consul/certs/{{ cert }}
    - user: consul
    - group: consul
    - mode: 644
{% endfor %}

{% elif 'node' in grains['id'] %}
replacing_agent_file:
  file.managed:
    - name: /etc/consul.d/client/config.json
    - source: salt://consul/files/agent_config.json
    - user: consul
    - group: consul
    - mode: 755
{% endif %}


transfer_web_ui:
  file.recurse:
    - name: /var/consul/web_ui
    - source: salt://consul/web_ui
    - user: consul
    - group: consul
    - unless: '[-f /var/consul/web_ui/consul_0.9.0-rc1_web_ui.zip ] && echo "Yes"'

