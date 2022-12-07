FROM php:8.0-rc-apache-buster

#moodle動作要件パッケージインストール＆設定
RUN apt update && apt -y install libzip-dev zip libpng-dev libicu-dev git netcat sudo
RUN docker-php-ext-install zip mysqli gd intl
RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini
RUN echo "max_input_vars = 5000" >> /usr/local/etc/php/php.ini
RUN sed -i -e "s/2M/1000M/g" /usr/local/etc/php/php.ini
#moodleダウンロード＆ドキュメントルートに移動
RUN cd /var/www/html && git clone -b MOODLE_400_STABLE https://github.com/moodle/moodle.git && mv moodle/* . && rm -rf moodle
#パーミッション設定
RUN chown www-data.www-data /var && chown -R www-data.www-data /var/www
#SSLに対応させる（オレオレ証明書）
RUN yes '' | openssl req -x509 -newkey rsa:4096 -nodes -sha256 -keyout /etc/ssl/private/ssl-cert-snakeoil.key -out /etc/ssl/certs/ssl-cert-snakeoil.pem -days 30
RUN a2enmod ssl && a2ensite default-ssl.conf
#インストール用バッチファイルをコピー
COPY install.sh /var/www/
RUN chmod 755 /var/www/install.sh
#デフォルトコマンド設定
CMD ["/var/www/install.sh"]
