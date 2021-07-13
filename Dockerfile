FROM linuxserver/wireshark

RUN apt-get update
RUN apt-get install -y sudo git python3-dev python3-distutils apt-utils openssl lsb-release cmake wget g++ curl gnupg

RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3 get-pip.py

# lab 4
ENV PATH="/root/.local/bin:${PATH}"
RUN pip3 install --user phe[cli] Pyfhel

# lab 3
RUN sudo apt-get install ca-certificates
RUN sudo cp /etc/wgetrc /
RUN printf "\nca_directory=/etc/ssl/certs/" | sudo tee -a /etc/wgetrc

WORKDIR /
RUN git clone https://github.com/zeutro/openabe


SHELL ["/bin/bash", "-c"]
ENV ZROOT="/openabe"
WORKDIR /openabe

RUN sudo -E ./deps/install_pkgs.sh
RUN . ./env
RUN export LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu/:${LD_LIBRARY_PATH}"
RUN make
RUN make install
RUN sudo -E make install

ENV LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"

RUN sudo apt-get remove -y ca-certificates && sudo apt-get autoremove

# lab 7

WORKDIR /app

RUN curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall
RUN chmod 755 msfinstall
RUN ./msfinstall

# lab 6

WORKDIR /

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
 		software-properties-common \
 		wget \
 		git \
		lib32gcc1 \
		lib32ncurses5 \
		lib32stdc++6 \
		lib32z1 \
		libc6-i386 \
		libgl1-mesa-dev \
		python-pip \
		python-dev \
		gcc \
 		python-tk \
 		curl \
 && echo "y" | apt-get install openjdk-8-jdk \
 && echo "y" | apt-get install openjdk-8-jre 

RUN apt-get install -y python-setuptools unzip \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

RUN cd / \
&& wget -qO- http://dl.google.com/android/android-sdk_r24.2-linux.tgz | tar xz -C /root/ --no-same-permissions \
&& chmod -R a+rX /root/android-sdk-linux \
&& echo y | /root/android-sdk-linux/tools/android update sdk --filter tools --no-ui --force -a \
&& echo y | /root/android-sdk-linux/tools/android update sdk --filter platform-tools --no-ui --force -a \
&& echo y | /root/android-sdk-linux/tools/android update sdk --filter android-16 --no-ui --force -a \
&& echo y | /root/android-sdk-linux/tools/android update sdk --filter sys-img-armeabi-v7a-android-16 --no-ui -a

ENV ANDROID_HOME="/root/android-sdk-linux" \
	PATH=$PATH:/root/android-sdk-linux/platform-tools:/root/android-sdk-linux/tools \
	ANDROID_EMULATOR_FORCE_32BIT=true \
	TERM=linux \
	TERMINFO=/etc/terminfo

RUN pwd \
&& cd /root/ \
&& git clone --recursive https://github.com/alexMyG/AndroPyTool.git \
&& wget https://github.com/alexMyG/AndroPyTool/releases/download/droidbox_images_patched/images_droidbox.zip \
&& unzip -o images_droidbox.zip -d AndroPyTool/DroidBox_AndroPyTool/images \
&& pip2 install wheel \
&& pip2 install -r AndroPyTool/requirements.txt \
&& touch AndroPyTool/avclass/__init__.py \
&& chmod 744 /root/AndroPyTool/run_androPyTool.sh

RUN pwd \
&& cd /root/ \
&& chmod 744 AndroPyTool/DroidBox_AndroPyTool/*.sh \
&& echo "no" | ./AndroPyTool/DroidBox_AndroPyTool/createDroidBoxDevice.sh

RUN adb devices; exit 0

EXPOSE 5554 5555

RUN wget https://github.com/secure-software-engineering/FlowDroid/releases/download/v2.8/soot-infoflow-cmd-jar-with-dependencies.jar

RUN mkdir /root/lab7
COPY lab6/reverse_tcp.apk /root/lab7
COPY lab6/SourcesAndSinks.txt /root/lab7

RUN mkdir /root/malwares
RUN git clone --no-hardlinks https://github.com/ashishb/android-malware/
RUN find android-malware -iname "*.apk" -exec cp -- "{}" malwares \;
RUN rm -rf android-malware

# create volumes
VOLUME /volumes
WORKDIR /volumes
