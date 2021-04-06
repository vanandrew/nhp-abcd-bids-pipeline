FROM dcanlabs/internal-tools:v1.0.0

RUN apt-get update && apt-get install -yq --no-install-recommends \
        apt-utils \
        python-pip \
        python3 \
        python3-dev \
        graphviz \
        wget

RUN pip install setuptools wheel
RUN pip install pyyaml numpy pillow pandas
RUN apt-get update && apt-get install -yq --no-install-recommends python3-pip
RUN pip3 install setuptools wheel

COPY ["app", "/app"]
RUN python3 -m pip install -r "/app/requirements.txt"

# insert pipeline code
ARG CACHEBUST=1
RUN git clone -b 'dev-10.5T-reg' --single-branch --depth 1 https://github.com/madisoth/dcan-macaque-pipeline.git /opt/pipeline 

# unless otherwise specified...
ENV OMP_NUM_THREADS=1
ENV SCRATCHDIR=/tmp/scratch
ENV ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=1
ENV TMPDIR=/tmp 

# setup ENTRYPOINT
COPY ["./entrypoint.sh", "/entrypoint.sh"]
COPY ["./SetupEnv.sh", "/SetupEnv.sh"]
ENTRYPOINT ["/entrypoint.sh"]
WORKDIR /
CMD ["--help"]

ENV HOME=/opt/

