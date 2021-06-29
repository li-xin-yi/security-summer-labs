FROM python:3.8

WORKDIR /usr/src/app
ENV PATH="/root/.local/bin:${PATH}"
RUN pip install --no-cache-dir --user phe[cli] Pyfhel


CMD ["/bin/bash"]
