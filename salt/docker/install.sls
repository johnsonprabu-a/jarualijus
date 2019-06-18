
# Ref: https://www.edureka.co/blog/docker-tutorial
#      https://docs.docker.com/install/linux/docker-ce/ubuntu/
# commands: https://www.edureka.co/blog/docker-commands/
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04


install_essentials:
  pkg.installed:
    - pkgs:
      - curl
      - apt-transport-https
      - ca-certificates
      - software-properties-common
    - refresh: True


manage_docker_repo:
  pkgrepo.managed:
    - name: deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable
    - file: /etc/apt/sources.list.d/docker.list
    - key_url: https://download.docker.com/linux/ubuntu/gpg
  pkg.installed:
    - name: docker-ce
    - requires:
      - pkg: install_essentials
    - refresh: True
