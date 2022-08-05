FROM php:8.0-rc-apache-buster

#moodle動作要件パッケージインストール＆設定
RUN apt update && apt -y install libzip-dev zip libpng-dev libicu-dev git netcat sudo
RUN docker-php-ext-install zip mysqli gd intl
RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini
RUN echo "max_input_vars = 5000" >> /usr/local/etc/php/php.ini
#moodleダウンロード＆ドキュメントルートに移動
RUN cd /var/www/html && git clone -b MOODLE_400_STABLE https://github.com/moodle/moodle.git && mv moodle/* . && rm -rf moodle
#パーミッション設定
RUN chown www-data.www-data /var && chown -R www-data.www-data /var/www
#インストール用バッチファイルをコピー
COPY install.sh /var/www/html
RUN chmod 755 /var/www/html/install.sh
#デフォルトコマンド設定
CMD ["/var/www/html/install.sh"]
