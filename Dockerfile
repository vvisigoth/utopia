FROM ubuntu:14.04

RUN apt-get update -y
RUN apt-get install -y git
RUN apt-get install -y python2.7
RUN apt-get install -y build-essential
RUN apt-get install -y libssl-dev
RUN apt-get install -y nodejs
RUN apt-get install -y npm

#Node needs symlinks
RUN ln -s /usr/bin/nodejs /usr/bin/node

# Setup home environment
RUN useradd dev
RUN mkdir /home/dev && chown -R dev: /home/dev
RUN mkdir -p /home/dev/bin /home/dev/lib /home/dev/include
ENV PATH /home/dev/bin:$PATH
ENV PKG_CONFIG_PATH /home/dev/lib/pkgconfig
ENV LD_LIBRARY_PATH /home/dev/lib

# Install vim with lua
RUN apt-get remove -y --purge vim vim-runtime vim-gnome vim-tiny vim-common vim-gui-common

RUN apt-get build-dep -y vim-gnome
RUN apt-get install -y liblua5.1-dev \
    luajit libluajit-5.1 python-dev ruby-dev \
    libperl-dev libncurses5-dev \
    libgnome2-dev libgnomeui-dev \
    libgtk2.0-dev libatk1.0-dev \
    libbonoboui2-dev libcairo2-dev \
    libx11-dev libxpm-dev libxt-dev 

RUN rm -rf /usr/local/share/vim

RUN mkdir /usr/include/lua5.1/include
RUN mv /usr/include/lua5.1/*.h /usr/include/lua5.1/include/

#RUN ln -s /usr/bin/luajit-2.0.0-beta9 /usr/bin/luajit

#We assume that vim has been pulled from git and is a subdirectory here

RUN mkdir -p /home/dev/vim
ADD vim /home/dev/vim

WORKDIR /home/dev/vim/src
#RUN rm auto/config.cache
#RUN make distclean
RUN ./configure --with-features=huge \
        --enable-rubyinterp \ 
        --enable-largefile \
        --disable-netbeans \
        --enable-pythoninterp \
        --with-python-config-dir=/usr/lib/python2.7/config \
        --enable-perlinterp \
        --enable-luainterp \
        --with-luajit \
        --enable-gui=auto \
        --enable-fail-if-missing \
        --with-lua-prefix=/usr/include/lua5.1 \
        --enable-cscope 
RUN make 
RUN make install

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

#This is somewhat obviated by dotfiles?
ADD dotfiles /home/dev/dotfiles
RUN bash dotfiles/setup.sh
RUN bash

# Link in shared parts of the home directory
RUN ln -s /var/shared/.ssh
RUN ln -s /var/shared/.bash_history

# Gitbook install
RUN npm install -g gitbook-cli
EXPOSE 4000




