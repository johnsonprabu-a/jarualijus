

{% set e_version = pillar.get('elk') %}

kibana-repo:
  pkgrepo.managed:
    - humanname: elk-repo
    - name: deb https://artifacts.elastic.co/packages/6.x/apt stable main
    - file: /etc/apt/sources.list.d/elastic-6.x.list
    - gpgcheck: 1
    - key_url: https://artifacts.elastic.co/GPG-KEY-elasticsearch

  pkg.installed:
    - name: kibana={{ e_version.kibana }}
    - refresh: True



kibana_autostart:
  cmd.run:
    - name: 'update-rc.d kibana defaults 95 10'

kibana_service:
  service.running:
    - name: kibana
    - enable: True
    - require:
      - pkg: kibana-repo
