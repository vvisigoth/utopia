# Modular Urbit Workspace

This is basically a Dockerfile and an install script to get you set up with an 
urbit development environment on a new computer. 
`install_urbit.sh` will likely have to be updated with the newest stable version 
of urbit\*.deb.

- Install git on host machine
- Pull this repo (you did)
- pull submodules `git submodule update --init --recursive`
- build docker: `docker build -t utopia .`
- start docker: `docker run -v <path_to_host_dir>:/home/dev -p 8443:8443 -it utopia`

![Urbit](http://media.urbit.org/site/blog-0.jpg)

