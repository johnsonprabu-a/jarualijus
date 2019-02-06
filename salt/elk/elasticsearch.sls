{% set e_config = pillar.get('el_config') %} 

elasticsearch-repo:
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


manage_config_file:
  file.managed:
    - name: /etc/elasticsearch/elasticsearch.yml
    - source: salt://elk/files/elasticsearch/elasticsearch.yml
    - user: elasticsearch
    - group: elasticsearch
    - mode: 660
    - template: jinja
    - require:
      - pkg: elasticsearch-repo
    - context: {
        CLNAME:                          {{ e_config.cluster }},
        HOST:                            {{ salt['grains.get']('ipv4')[1].split('-')[0] }}
    }
