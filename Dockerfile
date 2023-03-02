FROM quay.io/centos/centos:7

MAINTAINER Erik Jacobs <erikmjacobs@gmail.com>

ARG GOGS_VERSION="0.12.11"

LABEL name="Gogs - Go Git Service" \
      vendor="Gogs" \
      io.k8s.display-name="Gogs - Go Git Service" \
      io.k8s.description="The goal of this project is to make the easiest, fastest, and most painless way of setting up a self-hosted Git service." \
      summary="The goal of this project is to make the easiest, fastest, and most painless way of setting up a self-hosted Git service." \
      io.openshift.expose-services="3000,gogs" \
      io.openshift.tags="gogs" \
      build-date="2017-04-02" \
      version="${GOGS_VERSION}" \
      release="1"

ENV HOME=/var/lib/gogs

COPY ./root /

RUN curl -L -o /etc/yum.repos.d/gogs.repo https://dl.packager.io/srv/pkgr/gogs/pkgr/installer/el/7.repo && \
    yum -y install epel-release && \
    yum -y --setopt=tsflags=nodocs install nss_wrapper gettext && \
    yum -y clean all 

RUN adduser gogs && \
    mkdir /var/lib/gogs

RUN cd /tmp && curl -o gogs.tar.gz https://dl.gogs.io/${GOGS_VERSION}/gogs_${GOGS_VERSION}_linux_amd64.tar.gz && \
    tar -vxf gogs.tar.gz && \
    rm gogs.tar.gz && \
    mv gogs /opt/

RUN /usr/bin/fix-permissions /home/gogs && \
    /usr/bin/fix-permissions /var/lib/gogs && \
    /usr/bin/fix-permissions /opt/gogs 

EXPOSE 3000
USER gogs

CMD ["/usr/bin/rungogs"]
