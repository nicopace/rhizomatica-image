FROM phusion/baseimage:0.9.18
MAINTAINER nico@libre.ws

RUN apt-get update && apt-get -y install wget apt-utils
RUN apt-get -y install gnupg

# Configure apt to allow unauthenticated repos
RUN echo "APT::Get::AllowUnauthenticated "true";" > /etc/apt/apt.conf.d/90unsigned && \
    apt-get install -y apt-transport-https

# Configure repositories
RUN echo "deb [trusted=1] http://dev.rhizomatica.org/ubuntu/ precise main" > /etc/apt/sources.list.d/rhizomatica.list && \
    echo "deb [trusted=1] http://repo.rhizomatica.org/ubuntu/ precise main" >> /etc/apt/sources.list.d/rhizomatica.list && \
    echo "deb  http://deb.nodesource.com/node_0.10 jessie main" > /etc/apt/sources.list.d/nodesource.list && \
    wget -q https://deb.nodesource.com/gpgkey/nodesource.gpg.key -O- | apt-key add -

# Install packages
RUN apt-get update && \
    apt-get install -y \
            mosh git openvpn lm-sensors runit sqlite3 libffi-dev postgresql apache2 libapache2-mod-php5 \
            rrdtool python-psycopg2 python-pysqlite2 php5 php5-pgsql php5-curl php5-cli php5-gd python-yaml \
            python-formencode python-unidecode python-dateutil python3.4 php5 curl gawk sqlite3 php5-curl \
            php5-mysql php5-sqlite php5-oauth php5-json \
            kannel lcr osmocom-nitb

COPY overlay/*.deb /
RUN apt-get -y install netcat && \
    apt-get -y install \
    freeswitch freeswitch-lang-en freeswitch-mod-amr freeswitch-mod-amrwb freeswitch-mod-b64 freeswitch-mod-bv \
    freeswitch-mod-cluechoo freeswitch-mod-commands freeswitch-mod-conference freeswitch-mod-console freeswitch-mod-db \
    freeswitch-mod-dialplan-asterisk freeswitch-mod-dialplan-xml freeswitch-mod-dptools freeswitch-mod-enum \
    freeswitch-mod-esf freeswitch-mod-event-socket freeswitch-mod-expr freeswitch-mod-fifo freeswitch-mod-fsv \
    freeswitch-mod-g723-1 freeswitch-mod-h26x freeswitch-mod-hash freeswitch-mod-httapi freeswitch-mod-local-stream \
    freeswitch-mod-logfile freeswitch-mod-loopback freeswitch-mod-lua freeswitch-mod-native-file freeswitch-mod-python \
    freeswitch-mod-say-en freeswitch-mod-say-es freeswitch-mod-sms freeswitch-mod-sndfile freeswitch-mod-sofia \
    freeswitch-mod-spandsp freeswitch-mod-syslog freeswitch-mod-tone-stream freeswitch-mod-voicemail \
    freeswitch-mod-voicemail-ivr freeswitch-mod-xml-cdr freeswitch-mod-g729 freeswitch-sysvinit

COPY overlay/usr/local/bin/* /usr/local/bin/
COPY overlay/etc/cron.d/* /etc/cron.d/
COPY overlay/etc/default/* /etc/default/
COPY overlay/etc/freeswitch/ /etc/freeswitch/
COPY overlay/etc/osmocom/osmo-nitb.cfg /etc/osmocom/
COPY overlay/usr/lib/freeswitch/mod/* /usr/lib/freeswitch/mod/
COPY overlay/etc/service/ /etc/service/

ADD https://github.com/Rhizomatica/rccn/archive/master.zip /var/rhizomatica/

CMD ["/sbin/my_init"]
