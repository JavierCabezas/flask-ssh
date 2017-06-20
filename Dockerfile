## Ubuntu Dockerfile
## nginx
FROM ubuntu:16.04

## Install
RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list \
&& apt update \
&& apt install -y curl wget vim git nginx-full openssh-server supervisor python python-dev python-setuptools build-essential sqlite3 \
&& easy_install pip \
&& pip install uwsgi \
&& mkdir -p /var/run/sshd /var/log/supervisor \
&& rm -rf /var/lib/apt/lists/*

## Setting
RUN chown -R www-data:www-data /var/lib/nginx \
&& rm -f /etc/nginx/sites-enabled/default \
&& echo 'root:root' | chpasswd \
&& sed -i 's/PermitRootLogin/# PermitRootLogin/' /etc/ssh/sshd_config \
&& echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
&& echo "Asia/Seoul" > /etc/timezone \
&& dpkg-reconfigure tzdata

ADD app /app
RUN pip install -r /app/requirements.txt
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY mysite.conf /etc/nginx/sites-enabled/mysite.conf
EXPOSE 22 80 443

## For running
WORKDIR /app
CMD ["/usr/bin/supervisord"]
