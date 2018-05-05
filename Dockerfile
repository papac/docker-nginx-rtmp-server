# La plupart des gens qui diffusent en ligne aiment utiliser des services tels que Twitch.tv ou Ustream 
# pour diffuser de la vidéo aux spectateurs, et cela fonctionne assez bien. 
# Mais parfois vous voulez un peu plus de contrôle sur votre flux, 
# ou vous voulez que d'autres personnes puissent diffuser vers vous, ou vous voulez diffuser vers plusieurs endroits, 
# ou tout nombre de choses qui vous obligent à accéder à un flux RTMP réel de un serveur RTMP. 
# Ce guide couvrira les bases de la configuration d'un simple serveur RTMP sur un ordinateur Linux. 
# Ne vous inquiétez pas, ce n'est pas trop compliqué, mais se familiariser avec Linux vous aidera certainement.
FROM ubuntu:xenial

MAINTAINER Papac Dev <dakiafranck@gmail.com>

ENV SRC=/usr/src

RUN apt-get update && apt-get install -y --no-install-recommends

# Connectez-vous à votre boîte et assurez-vous d'avoir les outils nécessaires pour compiler nginx en utilisant la commande suivante:

RUN apt-get install \
	build-essential \
	unzip zip libpcre3 \
	libpcre3-dev libssl-dev \
	wget ffmpeg -y

# Maintenant, un peu d'infos sur nginx (prononcé "moteur-X"). 
# nginx est un serveur web extrêmement léger, mais quelqu'un a écrit un module RTMP pour cela, donc il peut aussi héberger des flux RTMP. 
# Cependant, pour ajouter le module RTMP, nous devons compiler nginx à partir de la source plutôt que d'utiliser le paquet apt. 
# Ne t'inquiète pas, c'est vraiment facile. Suivez simplement ces instructions. :)
RUN cd $SRC && \
	wget http://nginx.org/download/nginx-1.13.1.tar.gz && \
	wget https://github.com/arut/nginx-rtmp-module/archive/master.zip

# Décompactez / décompressez-les tous les deux et entrez le répertoire nginx:
RUN cd $SRC && \
	tar -zxvf nginx-1.13.1.tar.gz && \
	unzip master.zip

# Maintenant, nous construisons nginx:
RUN cd $SRC/nginx-1.13.1 && \
	./configure --with-http_ssl_module \
		--add-module=../nginx-rtmp-module-master \
		--prefix=/etc/nginx

# Maintenant on lance la compilation et l'installation
RUN cd $SRC/nginx-1.13.1 && make && make install 

# Maintenant on copie la configuration de nginx tout en base
RUN cat ./nginx.conf >> /etc/nginx/nginx.conf

VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

# Lancement du serveur
CMD ['/usr/local/nginx/sbin/nginx']

WORKDIR ['/etc/nginx']

# Maintenaint on expose les ports
EXPOSE 1935/tcp
EXPOSE 1935/upd