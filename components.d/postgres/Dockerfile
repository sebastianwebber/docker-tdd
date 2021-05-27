ARG FULL_BASE_IMAGE

FROM ${FULL_BASE_IMAGE} AS build
    ARG VERSION

    WORKDIR /code

    RUN dnf install -y \
        wget \
        bzip2

    RUN wget https://ftp.postgresql.org/pub/source/v${VERSION}/postgresql-${VERSION}.tar.bz2 && \
        tar xjf postgresql-${VERSION}.tar.bz2

    ## build tools
    RUN dnf install -y \
        readline-devel \
        zlib-devel \
        make \
        gcc

    WORKDIR /code/postgresql-${VERSION}

    RUN ./configure \
        --prefix=/usr/pgsql-13 \
        --includedir=/usr/pgsql-13/include \
        --mandir=/usr/pgsql-13/share/man \
        --datadir=/usr/pgsql-13/share \
        --libdir=/usr/pgsql-13/lib \
        --with-system-tzdata=/usr/share/zoneinfo \
        --sysconfdir=/etc/sysconfig/pgsql \
        --docdir=/usr/pgsql-13/doc
    RUN make install -j 16
    RUN make install -j 16 -C contrib

FROM ${FULL_BASE_IMAGE}

    RUN dnf install -y \
        readline \
        zlib

    COPY --from=build /usr/pgsql-13  /usr/pgsql-13

    RUN useradd --home-dir /var/lib/pgsql postgres

    USER postgres

