elk-repo:
  pkgrepo.managed:
    - humanname: elk-repo
    - name: deb https://artifacts.elastic.co/packages/6.x/apt stable main
    - file: /etc/apt/sources.list.d/elastic-6.x.list
    - gpgcheck: 1
    - key_url: https://artifacts.elastic.co/GPG-KEY-elasticsearch

  pkg.installed:
    - name: elasticsearch=6.6.0
    - refresh: True

elasticsearch_daemon_reload:
  cmd.run:
    - name: 'update-rc.d elasticsearch defaults 95 10'

filebeat_service:
  service.running:
    - name: elasticsearch
    - enable: True
    - require:
      - pkg: elk-repo


# Load the Wazuh template for Elasticsearch

## Reference: https://documentation.wazuh.com/current/user-manual/kibana-app/troubleshooting.html

# curl https://raw.githubusercontent.com/wazuh/wazuh/3.8/extensions/elasticsearch/wazuh-elastic6-template-alerts.json | curl -X PUT "http://localhost:9200/_template/wazuh" -H 'Content-Type: application/json' -d @-

