#!/bin/bash
#データベースが起動しているかどうかをチェック
echo "データベース待機中"
while ! nc -w 1 docker-moodle-mariadb 3306; do
    echo -n ".";
    sleep 1;
done

cd /var/www/html/ && sudo -u www-data php admin/cli/install.php \
--non-interactive \
--agree-license \
--allow-unstable \
--skip-database \
--lang=ja \
--wwwroot=http://localhost:8080 \
--dataroot=/var/www/moodledata \
--dbtype=mariadb \
--dbhost=docker-moodle-mariadb \
--dbport=3306 \
--dbname=moodle \
--dbuser=root \
--dbpass=moodle \
--fullname="mdl-docker-3.8" \
--shortname="mdl-docker-3.8" \
--adminuser=admin \
--adminpass=admin \
--adminemail=admin@example.com

cd /var/www/html/ && sudo -u www-data php admin/cli/install_database.php \
--lang=ja \
--adminuser=admin \
--adminpass=admin \
--adminemail=admin@example.com \
--fullname="mdl-docker-3.8" \
--shortname="mdl-docker3.8" \
--agree-license

#apache2起動
apache2-foreground
