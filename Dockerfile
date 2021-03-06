FROM    ubuntu:16.04

ENV     MCROUTER_DIR            /usr/local/mcrouter
ENV     MCROUTER_REPO           https://github.com/facebook/mcrouter.git
ENV     MCROUTER_TAG            release-40-0
ENV     DEBIAN_FRONTEND         noninteractive
ENV     MAKE_ARGS               -j8

ADD     clean_ubuntu_16.04.sh /tmp

RUN     apt-get update && apt-get install -y --no-install-recommends ca-certificates git sudo && \
        mkdir -p $MCROUTER_DIR/repo && \
        cd $MCROUTER_DIR/repo && git clone $MCROUTER_REPO && \
        cd $MCROUTER_DIR/repo/mcrouter  && git checkout $MCROUTER_TAG && \
        cd $MCROUTER_DIR/repo/mcrouter/mcrouter/scripts && \
        ./install_ubuntu_16.04.sh $MCROUTER_DIR $MAKE_ARGS && \
        /tmp/clean_ubuntu_16.04.sh $MCROUTER_DIR && rm -rf $MCROUTER_DIR/repo && \
        apt-get clean &&  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
        ln -s $MCROUTER_DIR/install/bin/mcrouter /usr/local/bin/mcrouter

ENV     DEBIAN_FRONTEND newt

RUN     mkdir /var/spool/mcrouter
VOLUME  /var/spool/mcrouter

RUN     mkdir /usr/local/etc/mcrouter
VOLUME  /usr/local/etc/mcrouter

CMD     ["/usr/local/bin/mcrouter"]
