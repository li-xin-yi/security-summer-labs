FROM python:3.8

VOLUME [ "/root/volume" ]
WORKDIR /root/volume
COPY he-gow.zip /root/volume
ENV PATH="/root/.local/bin:${PATH}"
RUN pip install --user phe[cli] Pyfhel
RUN apt-get update
RUN apt-get install nano vim unzip


CMD ["/bin/bash"]
