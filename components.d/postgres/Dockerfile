ARG FULL_BASE_IMAGE

FROM ${FULL_BASE_IMAGE} AS build
    ARG VERSION
    ARG BASE_VERSION

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
        --prefix=/usr/pgsql-${BASE_VERSION} \
        --includedir=/usr/pgsql-${BASE_VERSION}/include \
        --mandir=/usr/pgsql-${BASE_VERSION}/share/man \
        --datadir=/usr/pgsql-${BASE_VERSION}/share \
        --libdir=/usr/pgsql-${BASE_VERSION}/lib \
        --with-system-tzdata=/usr/share/zoneinfo \
        --sysconfdir=/etc/sysconfig/pgsql \
        --docdir=/usr/pgsql-${BASE_VERSION}/doc
    RUN make install -j 16
    RUN make install -j 16 -C contrib

FROM ${FULL_BASE_IMAGE}
    ARG BASE_VERSION

    RUN dnf install -y \
        readline \
        zlib

    COPY --from=build /usr/pgsql-${BASE_VERSION}  /usr/pgsql-${BASE_VERSION}

    RUN useradd --home-dir /var/lib/pgsql postgres

    USER postgres

