FROM ubuntu:14.04

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update -y
RUN apt-get install -y git
RUN apt-get install -y tmux
RUN apt-get install -y python2.7
RUN apt-get install -y build-essential
RUN apt-get install -y libssl-dev
RUN apt-get install -y vim
RUN apt-get install -y curl

# Setup home environment
RUN useradd dev
RUN mkdir /home/dev && chown -R dev: /home/dev
RUN mkdir -p /home/dev/bin /home/dev/lib /home/dev/include
ENV PATH /home/dev/bin:$PATH
ENV PKG_CONFIG_PATH /home/dev/lib/pkgconfig
ENV LD_LIBRARY_PATH /home/dev/lib

# Create a shared data volume
# We need to create an empty file, otherwise the volume will
# belong to root.
# This is probably a Docker bug.
RUN mkdir /var/shared/
RUN touch /var/shared/placeholder
RUN chown -R dev:dev /var/shared
VOLUME /var/shared

WORKDIR /home/dev
ENV HOME /home/dev

ADD dotfiles /home/dev/dotfiles
RUN bash dotfiles/setup.sh
RUN bash

# Link in shared parts of the home directory
RUN ln -s /var/shared/.ssh
RUN ln -s /var/shared/.bash_history

#Urbit installation needs a script to catch errors
ADD install_urbit.sh /home/dev/install_urbit.sh
RUN bash install_urbit.sh

