#!/bin/bash

# Install urbit

curl -O https://media.urbit.org/dist/debian/urbit_0.4.3-1_amd64.deb

if dpkg -i urbit_0.4.3-1_amd64.deb; then
    echo "it worked the first time!"
else
    apt-get -f install -y
fi

exit 0
