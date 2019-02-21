#Ref: https://logz.io/blog/elasticsearch-cluster-tutorial/

{% set e_version = pillar.get('elk') %}
{% set e_config = pillar.get('el_config') %} 

elasticsearch-repo:
  pkgrepo.managed:
    - humanname: elk-repo
    - name: deb https://artifacts.elastic.co/packages/6.x/apt stable main
    - file: /etc/apt/sources.list.d/elastic-6.x.list
    - gpgcheck: 1
    - key_url: https://artifacts.elastic.co/GPG-KEY-elasticsearch

  pkg.installed:
    - name: elasticsearch={{ e_version.elasticsearch }}
    - refresh: True

elasticsearch_autostart:
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
        HOST:                            {{ salt['grains.get']('ipv4')[1].split('-')[0] }},
        NNAME:                           {{ grains['id'] }}
    }

#Ref: https://docs.saltstack.com/en/latest/ref/states/all/salt.states.file.html#salt.states.file.append

/etc/default/elasticsearch:
  file.append:
    - text:
      - MAX_LOCKED_MEMORY=unlimited

/etc/sysctl.conf:
  file.append:
    - text:
      - vm.max_map_count=262144

/etc/security/limits.conf:
  file.append:
    - text:
      - '* soft nofile 100000'
      - '* hard nofile 100000'



Service_check_restart:
  service.running:
    - name: elasticsearch
    - enable: True
    - full_restart: True
    - require:
      - pkg: elasticsearch-repo
    - watch:
      - file: manage_config_file
