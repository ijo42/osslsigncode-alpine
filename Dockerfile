FROM alpine:latest
ENV GLIBC_REPO=https://github.com/sgerrand/alpine-pkg-glibc GLIBC_VERSION=2.31-r0

RUN /bin/sh -c set -ex && apk -U upgrade && apk add libstdc++ curl ca-certificates bash unzip automake autoconf libtool libcurl curl-dev libressl-dev autoconf g++ make && \
echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
cd /tmp && curl -SsLo /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
curl -SsLo glibc-${GLIBC_VERSION}.apk ${GLIBC_REPO}/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk && \
curl -SsLo glibc-bin-${GLIBC_VERSION}.apk ${GLIBC_REPO}/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk && \
curl -SsLo glibc-i18n-${GLIBC_VERSION}.apk ${GLIBC_REPO}/releases/download/${GLIBC_VERSION}/glibc-i18n-${GLIBC_VERSION}.apk && \
apk add *.apk && rm -v *.apk \
/usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 && \
mkdir /tmp/osslsigncode && cd /tmp/osslsigncode &&  PATH=/usr/glibc-compat/sbin:/usr/glibc-compat/bin:$PATH  && \
curl -SsLo master.zip "https://github.com/mtrojnar/osslsigncode/archive/master.zip" && unzip master.zip && \
cd osslsigncode-master &&  ./autogen.sh && ./configure && make && make install && make clean && \
apk del unzip  automake autoconf curl curl-dev libressl-dev autoconf g++ make && rm -rf /tmp/* /usr/share/doc /var/cache/apk

ENTRYPOINT ["osslsigncode"]
CMD ["-v"]