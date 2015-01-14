FROM phusion/baseimage:0.9.15
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
ENV TERM screen
MAINTAINER x0nic <nathan@globalphobia.com>

#Name and Version
ENV CNAME nzbdrone
ENV CVER 2.0.0.2594

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody
RUN usermod -g 100 nobody

# Use specified version of sonarr for more consistent builds
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC \
  && echo "deb http://apt.sonarr.tv/ master main" | tee -a /etc/apt/sources.list \
  && apt-get update -q \
  && apt-get install -qy $CNAME=$CVER \
  ; apt-get clean \
  ; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN chown -R nobody:users /opt/NzbDrone \
  ; mkdir -p /config \
  && chown -R nobody:users /config

RUN apt-get update -q
RUN apt-get install -qy libmono-cil-dev nzbdrone
RUN chown -R nobody:users /opt/NzbDrone

VOLUME /config
VOLUME /downloads
VOLUME /tv

EXPOSE 8989

# Add nzbdrone to runit
RUN mkdir /etc/service/nzbdrone
ADD nzbdrone.sh /etc/service/nzbdrone/run
RUN chmod +x /etc/service/nzbdrone/run