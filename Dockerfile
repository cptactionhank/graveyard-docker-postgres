FROM ubuntu:14.04
# add maintainer info
MAINTAINER cptactionhank <cptactionhank@users.noreply.github.com>

ENV PGDATA /var/lib/postgresql/9.3/main/

# setup locale stuff
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN locale-gen en_US en_US.UTF-8 && update-locale

# Add the PostgreSQL PGP key to verify their Debian packages.
# It should be the same key as https://www.postgresql.org/media/keys/ACCC4CF8.asc
# Add PostgreSQL's repository. It contains the most recent stable release
#     of PostgreSQL, ``9.3``.
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8 \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" \
      > /etc/apt/sources.list.d/pgdg.list

# Install PostgreSQL ``9.3`` and remove existing database.
RUN apt-get update -qq \
    && apt-get -qqy install postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3 \
    && rm -rf /var/lib/postgresql/9.3/main

# make the default running user ``postgres``
USER postgres

# initialize new DB with configurations files there
RUN /usr/lib/postgresql/9.3/bin/initdb

# Expose the PostgreSQL port
EXPOSE 5432

VOLUME ["/var/lib/postgresql/9.3/main/", "/var/run/postgresql"]

# Set the default command to run when starting the container
ENTRYPOINT ["/usr/lib/postgresql/9.3/bin/postgres"]
