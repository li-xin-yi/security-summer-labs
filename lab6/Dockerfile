FROM opensecurity/mobile-security-framework-mobsf

RUN apt-get update
RUN apt-get install -y wget android-sdk

WORKDIR /root

RUN wget https://github.com/secure-software-engineering/FlowDroid/releases/download/v2.8/soot-infoflow-cmd-jar-with-dependencies.jar

COPY SourcesAndSinks.txt /root
ENV PATH=$JAVA_HOME/bin:$PATH
ENV ANDROID_SDK=/usr/lib/android-sdk/

RUN mkdir /root/apks

VOLUME /root/volume
WORKDIR /root/apks

RUN wget https://github.com/ashishb/android-malware/raw/master/BreakBottleneck/SamplesOfHIP2014TalkBreakBottleneck/Claco.A/Claco.A.apk
RUN wget https://github.com/ashishb/android-malware/blob/master/BreakBottleneck/SamplesOfHIP2014TalkBreakBottleneck/Dropdialer.A/Dropdialer.apk
RUN wget https://github.com/ashishb/android-malware/raw/master/BreakBottleneck/SamplesOfHIP2014TalkBreakBottleneck/Obad.A/Obad.A.apk

WORKDIR /root/Mobile-Security-Framework-MobSF
COPY lab_entry.sh .
RUN chmod +x lab_entry.sh

CMD ["/root/Mobile-Security-Framework-MobSF/lab_entry.sh"]