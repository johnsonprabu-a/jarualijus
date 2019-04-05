#Error_FIX: [AttributeError: 'module' object has no attribute 'SSL_ST_INIT']
#https://stackoverflow.com/questions/43267157/python-attributeerror-module-object-has-no-attribute-ssl-st-init

wordpress:
  image: wordpress
  links:
    - wordpress_db:mysql
  ports:
    - 8080:80
wordpress_db:
  image: mariadb
  environment:
    MYSQL_ROOT_PASSWORD: Alpha
phymyadmin:
  image: corbinu/docker-phpmyadmin
  links:
    - wordpress_db:mysql
  ports:
    - 8181:80
  environment:
    MYSQL_USERNAME: root
    MYSQL_ROOT_PASSWORD: Alpha

