# Use Ubuntu 16.04 LTS
FROM ubuntu:xenial-20180808

MAINTAINER <hrejali@uwo.ca>

run mkdir -p /src/install_scripts
COPY ./install_scripts/*.sh /src/install_scripts/

RUN bash /src/install_scripts/00_install_basics.sh > log_00_basics
RUN bash /src/install_scripts/05_install_epilepsyhistology.sh > log_05_epilepsyhistology.sh > log_05_epilepsyhistology

# Remove install scripts
RUN rm -rf /src

