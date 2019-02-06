#Version: 3.8

pkg_essentials:
  pkg.latest:
    - names:
      - curl
      - apt-transport-https
      - lsb-release
   
creating_symlink_python_2.7:
  file.symlink:
    - name: /usr/bin/python
    - target: /usr/bin/python3
    - unless: '[ -f /usr/bin/python ] && echo "Yes"'
    - user: root
    - group: root 


wazuh-repo:
  pkgrepo.managed:
    - humanname: wazuh-repo
    - name: deb https://packages.wazuh.com/3.x/apt/ stable main
    - file: /etc/apt/sources.list.d/wazuh.list
    - gpgcheck: 1
    - key_url: https://packages.wazuh.com/key/GPG-KEY-WAZUH

  pkg.installed:
    - name: wazuh-manager=3.8.1-1
    - refresh: True

wazuh_service:
  service.running:
    - name: wazuh-manager
    - enable: True
    - reload: True
    - require:
      - pkg: wazuh-repo

nodejs_source:
  cmd.run:
    - name: 'curl -sL https://deb.nodesource.com/setup_8.x | bash'
   
installing_nodejs:
  pkg.latest:
    - name: nodejs
    - refresh: True
    - require:
      - cmd: nodejs_source

wazuh_api_installation:
  pkg.installed:
    - name: wazuh-api=3.8.1-1
    - refresh: True
    - require:
      - pkg: installing_nodejs

wazuh_api_service:
  service.running:
    - name: wazuh-api
    - enable: True
    - refresh: True
    - require:
      - pkg: wazuh_api_installation

