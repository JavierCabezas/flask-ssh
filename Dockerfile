FROM ubuntu
ENV TZ=America/Santiago
RUN apt-get update

## Install
RUN apt-get update \
&& apt-get install -y --no-install-recommends apt-utils \
&& apt-get install -y python3.7 \
&& ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
&& apt-get install -y python3-pip \
&& apt-get install -y curl wget vim git nginx-full openssh-server supervisor build-essential sqlite3 \
&& pip3 install uwsgi \
&& mkdir -p /var/run/sshd /var/log/supervisor \
&& rm -rf /var/lib/apt/lists/*

## Setting
RUN chown -R www-data:www-data /var/lib/nginx \
&& rm -f /etc/nginx/sites-enabled/default \
&& echo 'root:root' | chpasswd \
&& sed -i 's/PermitRootLogin/# PermitRootLogin/' /etc/ssh/sshd_config \
&& echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
&& echo $TZ > /etc/timezone

ADD app /app
RUN pip3 install -r /app/requirements.txt
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY mysite.conf /etc/nginx/sites-enabled/mysite.conf
EXPOSE 22 80 443

## For running
WORKDIR /app
CMD ["/usr/bin/supervisord"]
