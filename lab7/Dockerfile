FROM linuxserver/wireshark

RUN apt update && apt install -y dialog apt-utils && apt install -y adb curl gnupg dialog
RUN curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall
RUN chmod 755 msfinstall
RUN ./msfinstall

WORKDIR /app