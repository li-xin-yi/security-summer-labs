FROM alexmyg/andropytool


WORKDIR /root

RUN wget https://github.com/secure-software-engineering/FlowDroid/releases/download/v2.8/soot-infoflow-cmd-jar-with-dependencies.jar

RUN mkdir /root/lab7
COPY reverse_tcp.apk /root/lab7
COPY SourcesAndSinks.txt /root/

RUN mkdir /root/malwares
RUN git clone --no-hardlinks https://github.com/ashishb/android-malware/
RUN find android-malware -iname "*.apk" -exec cp -- "{}" malwares \;
RUN rm -rf android-malware

ENTRYPOINT ["/bin/bash"]