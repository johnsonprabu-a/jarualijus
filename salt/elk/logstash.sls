
{% set e_version = pillar.get('elk') %}

logstash-repo:
  pkgrepo.managed:
    - humanname: elk-repo
    - name: deb https://artifacts.elastic.co/packages/6.x/apt stable main
    - file: /etc/apt/sources.list.d/elastic-6.x.list
    - gpgcheck: 1
    - key_url: https://artifacts.elastic.co/GPG-KEY-elasticsearch

  pkg.installed:
    - name: logstash={{ e_version.logstash }}
    - refresh: True


logstash_service:
  service.running:
    - name: logstash
    - enable: True
    - require:
      - pkg: logstash-repo
