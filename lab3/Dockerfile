FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

SHELL ["/bin/bash", "-c"]
RUN apt-get update && apt-get install -y git apt-utils python3-pip openssl lsb-release cmake wget bison sudo 
RUN sudo apt install ca-certificates
RUN printf "\nca_directory=/etc/ssl/certs/" | sudo tee -a /etc/wgetrc
RUN git clone https://github.com/zeutro/openabe

ENV ZROOT="/openabe"
WORKDIR /openabe

RUN sudo -E ./deps/install_pkgs.sh
RUN . ./env
RUN export LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu/:${LD_LIBRARY_PATH}"
RUN make
RUN make install
RUN sudo -E make install

ENV LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"

CMD ["/bin/bash"]