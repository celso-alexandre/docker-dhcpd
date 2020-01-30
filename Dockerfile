FROM ubuntu:18.04

LABEL mainteiner="Celso Alexandre <celso-alexandre@NOSPAM.no>"

ARG DEBIAN_FRONTEND=noninteractive

# DHCP installation
RUN apt-get -q -y update \
 && apt-get -q -y -o "DPkg::Options::=--force-confold" -o "DPkg::Options::=--force-confdef" install apt-utils \
 && rm /etc/dpkg/dpkg.cfg.d/excludes \
 && apt-get -q -y -o "DPkg::Options::=--force-confold" -o "DPkg::Options::=--force-confdef" install dumb-init isc-dhcp-server man \
 && apt-get -q -y autoremove \
 && apt-get -q -y clean \
 && rm -rf /var/lib/apt/lists/*

# Install basic packages
RUN apt-get update
RUN apt-get install -y nano

# Install supervisor, to run webmin in background
RUN apt-get install -y supervisor

# apt-show-versions bug fix: https://groups.google.com/forum/#!topic/beagleboard/jXb9KhoMOsk
RUN rm -f /etc/apt/apt.conf.d/docker-gzip-indexes
RUN apt-get purge -y apt-show-versions
RUN rm -f /var/lib/apt/lists/*lz4
RUN apt-get -o Acquire::GzipIndexes=false update
RUN apt-get install -y apt-show-versions

# Install webmin dependencies
RUN apt-get install -y unzip wget libnet-ssleay-perl libauthen-pam-perl libio-pty-perl shared-mime-info python

# Webmin install
RUN wget https://prdownloads.sourceforge.net/webadmin/webmin_1.941_all.deb
RUN dpkg -i webmin_1.941_all.deb

COPY util/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
