# i was not aware, but alpine builds with libmusl,
# and apparently oracle java only works on glibc,
# this entire dockerfile (with little modifications)
# is from here:
# https://github.com/cgswong/docker-alpine-java/blob/master/jdk/Dockerfile
# for more information see here:
# https://github.com/gliderlabs/docker-alpine/issues/11

# the resulting docker image should be around 65MB

FROM alpine:latest

# Setup environment
ENV JAVA_PKG=jdk \
    JAVA_VERSION_MAJOR=8 \
    JAVA_VERSION_MINOR=151 \
    JAVA_VERSION_BUILD=12 \
    JAVA_BASE=/usr/local/java
ENV JAVA_HOME="${JAVA_BASE}/jdk"
ENV PATH="${PATH}:${JAVA_HOME}/bin" \
    LANG="en_US.UTF-8" \
    GLIBC_VERSION=2.25-r0

RUN apk --no-cache upgrade --update &&\
    apk --no-cache add --update \
      ca-certificates \
      curl \
      libstdc++ &&\
    for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION} glibc-i18n-${GLIBC_VERSION}; do curl -sSL https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; done && \
    apk --allow-untrusted add /tmp/*.apk &&\
    ( /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 ${LANG} || true ) &&\
    echo "export LANG=${LANG}" > /etc/profile.d/locale.sh &&\
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib &&\
    # Install Java
    mkdir -p ${JAVA_BASE} &&\
    curl -sSL --header "Cookie: oraclelicense=accept-securebackup-cookie" \
      http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/e758a0de34e24606bca991d704f6dcbf/${JAVA_PKG}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz | tar zxf - -C ${JAVA_BASE} &&\
    ln -s ${JAVA_BASE}/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} ${JAVA_HOME} &&\
    # Install unlimited JCE
    curl -sSL --header "Cookie: oraclelicense=accept-securebackup-cookie" --output /tmp/jce_policy-${JAVA_VERSION_MAJOR}.zip \
      http://download.oracle.com/otn-pub/java/jce/${JAVA_VERSION_MAJOR}/jce_policy-${JAVA_VERSION_MAJOR}.zip &&\
    unzip -q /tmp/jce_policy-${JAVA_VERSION_MAJOR}.zip -d /tmp/ &&\
    cp -R /tmp/UnlimitedJCEPolicyJDK8/*.jar ${JAVA_HOME}/jre/lib/security &&\
    # DNS fixup
    sed -i s/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=30/ ${JAVA_HOME}/jre/lib/security/java.security &&\
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf &&\
    # Cleanup
    apk del curl glibc-i18n &&\
    rm -rf /tmp/* \
        ${JAVA_HOME}/*src.zip \
        ${JAVA_HOME}/lib/missioncontrol \
        ${JAVA_HOME}/lib/visualvm \
        ${JAVA_HOME}/lib/*javafx* \
        ${JAVA_HOME}/jre/lib/plugin.jar \
        ${JAVA_HOME}/jre/lib/ext/jfxrt.jar \
        ${JAVA_HOME}/jre/bin/javaws \
        ${JAVA_HOME}/jre/lib/javaws.jar \
        ${JAVA_HOME}/jre/lib/desktop \
        ${JAVA_HOME}/jre/plugin \
        ${JAVA_HOME}/jre/lib/deploy* \
        ${JAVA_HOME}/jre/lib/*javafx* \
        ${JAVA_HOME}/jre/lib/*jfx* \
        ${JAVA_HOME}/jre/lib/amd64/libdecora_sse.so \
        ${JAVA_HOME}/jre/lib/amd64/libprism_*.so \
        ${JAVA_HOME}/jre/lib/amd64/libfxplugins.so \
        ${JAVA_HOME}/jre/lib/amd64/libglass.so \
        ${JAVA_HOME}/jre/lib/amd64/libgstreamer-lite.so \
        ${JAVA_HOME}/jre/lib/amd64/libjavafx*.so \
        ${JAVA_HOME}/jre/lib/amd64/libjfx*.so

# java version
RUN java -version

# Start container
CMD ["java","-Djava.security.egd=file:/dev/urandom"]
