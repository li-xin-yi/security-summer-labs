FROM python:3.8

VOLUME [ "/root/volume" ]
WORKDIR /root/volume
ENV PATH="/root/.local/bin:${PATH}"
RUN pip install --user phe[cli] Pyfhel

CMD ["/bin/bash"]
