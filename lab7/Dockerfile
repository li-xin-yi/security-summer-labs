FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /root

RUN apt update && apt install -y dialog apt-utils && apt install -y adb curl gnupg
RUN curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall
RUN chmod 755 msfinstall
RUN ./msfinstall

EXPOSE 4444

VOLUME ["/root/volume"]