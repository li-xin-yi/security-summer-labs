FROM ubuntu:20.04

RUN apt update && apt install -y adb curl gnupg
RUN curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall
RUN chmod 755 msfinstall
RUN ./msfinstall

WORKDIR /app

CMD ["/bin/bash"]