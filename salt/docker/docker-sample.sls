moving_docker_config:
  file.managed:
    - name: /opt/Dockerfile
    - source: salt://docker/config_files/docker_sample
    - mode: 700
    - user: root
    - group: root

executing_config:
  cmd.run:
    - cwd: /opt
    - name: "docker build ."
    - require:
      - file: moving_docker_config
