FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

SHELL ["/bin/bash", "-c"]
RUN apt-get update && apt-get install -y apt-utils git python3-pip openssl lsb-release cmake wget bison sudo 
RUN sudo apt install ca-certificates
RUN printf "\nca_directory=/etc/ssl/certs/" | sudo tee -a /etc/wgetrc
RUN git clone https://github.com/zeutro/openabe
RUN cd openabe &&\
    chmod +x ./deps/install_pkgs.sh &&\
    ./deps/install_pkgs.sh &&\
    . ./env &&\
    mkdir bin &&\
    ln -s /bin/bison /openabe/bin/bison &&\
    export LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu/:${LD_LIBRARY_PATH}" &&\
    make &&\ 
    make install

CMD ["/bin/bash"]