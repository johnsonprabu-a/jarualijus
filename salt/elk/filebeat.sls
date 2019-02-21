
{% set e_version = pillar.get('elk') %}

filebeat-repo:
  pkgrepo.managed:
    - humanname: elk-repo
    - name: deb https://artifacts.elastic.co/packages/6.x/apt stable main
    - file: /etc/apt/sources.list.d/elastic-6.x.list
    - gpgcheck: 1
    - key_url: https://artifacts.elastic.co/GPG-KEY-elasticsearch

  pkg.installed:
    - name: filebeat={{ e_version.filebeat }}
    - refresh: True

#download_filebeat_config:
#  cmd.run:
#    - 'curl -so /etc/filebeat/filebeat.yml https://raw.githubusercontent.com/wazuh/wazuh/3.8/extensions/filebeat/filebeat.yml'
#    - require:
#      - pkg: elk-repo

filebeat_autostart:
  cmd.run:
    - name: 'update-rc.d filebeat defaults 95 10'

filebeat_service:
  service.running:
    - name: filebeat
    - enable: True
    - require:
      - pkg: filebeat-repo
