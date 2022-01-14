FROM debian
MAINTAINER  Nikolay Grinkevich
ENV TZ=Europe/Moscow
##Выполнить обновление apt-кеша (Д)
##Обновить все пакеты в контейнере (Д)
##Установить веб сервер nginx (Д)
##Очистить скачанный apt-cache (Д)
##Удалить содержимое директории /var/www/ (Д)
##Создать в директории /var/www/ директорию с именем вашего сайта и папку с картинками (company.com/img) (Д)
RUN echo "deb http://mirror.yandex.ru/debian bullseye-updates main" >> /etc/apt/sources.list.d/yandex.list  && \
    apt-get update && \
    apt-get -q -y upgrade >/dev/null  && \
    apt-get -q -y install >/dev/null \
    nginx  \
    procps && \
    apt-get clean  && \
    rm -rf /var/www/* && \
    mkdir -p /var/www/company.com/img
##Поместить из папки с докер файлом в директорию /var/www/company.com/img файл img.jpg (поместить туда какую-нибудь картинку). (Х,Д)
COPY index.html /var/www/company.com/index.html
COPY img/uc.jpg /var/www/company.com/img/uc.jpg
##Задать рекурсивно на папку /var/www/company.com права "владельцу - читать, писать, исполнять;
##группе - читать, исполнять, остальным - только читать" (Д)
##С помощью команды useradd создать пользователя <ваше имя> (Д)
##С помощью команды groupadd создать группу <ваша фамилия> (Д)
##С помощью команды usermod поместить пользователя <ваше имя> в группу <ваша фамилия> (Д)
##Рекурсивно присвоить созданных пользователя и группу на папку /var/www/company.com (Д)
##Воспользоваться конструкцией (sed -i 's/ЧТО ЗАМЕНИТЬ/НА ЧТО ЗАМЕНИТЬ/g' имя_файла)
##и заменить в файле /etc/nginx/sites-enabled/default следующую подстроку (/var/www/html) так, чтобы она соответствовала (/var/www/company.com) (Д)
##С помощью команды grep найти в каком файле задается пользователь (user), от которого запускается nginx (К)
##grep -rnw '/etc/nginx/nginx.conf' -e 'user'
##С помощью команды sed проделать операцию замены пользователя в файле найденном в пункте 17 на вашего пользователя (Д)
RUN chmod -R 754 /var/www/company.com/ && \
    groupadd -r grinkevich && \
    useradd --no-log-init -r  nikolay && \
    usermod -a -G grinkevich nikolay && \
    chown nikolay:grinkevich -R /var/www/company.com/ && \
    sed -i 's+/var/www/html;+/var/www/company.com;+g' /etc/nginx/sites-enabled/default && \
    sed -i 's/www-data/nikolay/g' /etc/nginx/nginx.conf

EXPOSE 80/tcp
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]