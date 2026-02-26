# Image for building python wrapper 
FROM centos:7 AS builder

# Copy SDK to temp image
COPY "./bin/" /home/idengine/bin/
COPY "./bindings/" /home/idengine/bindings/
COPY "./include/" /home/idengine/include/
COPY "./data-zip/" /home/idengine/data-zip/
COPY "./samples/" /home/idengine/samples/
WORKDIR "/home/idengine/samples/idengine_sample_python/"

## CentOS7 only has cmake v2.8 but idengine requied v3.0
RUN set -xe \
	&& yum -y install gcc \
	&& yum -y install gcc-c++ \
	&& yum -y install make \
	&& yum -y install cmake \
	&& yum -y install epel-release \
	&& yum -y install cmake3 \
	&& ln -f -s /usr/bin/cmake3 /usr/bin/cmake

RUN set -xe \
	&& yum -y install gcc openssl-devel bzip2-devel libffi-devel zlib-devel \
	&& yum -y install wget \
	&& cd /tmp/ \
	&& wget https://www.python.org/ftp/python/3.10.5/Python-3.10.5.tgz \
	&& tar xzf Python-3.10.5.tgz \
	&& cd Python-3.10.5 \
	&& ./configure --enable-optimizations --enable-shared \
	&& make altinstall 


ENV LD_LIBRARY_PATH /tmp/Python-3.10.5

RUN ./build_python_wrapper.sh "../../bin" 3.10

RUN python3.10 -m venv --copies /venv

# Image for production
FROM centos:7

ENV LD_LIBRARY_PATH /home/idengine/

# compiled python
COPY --from=builder /venv /venv
COPY --from=builder /usr/local/lib/ /usr/local/lib/
COPY --from=builder /tmp/Python-3.10.5/libpython3.10.so.1.0 /home/idengine/


# Idengine libs
COPY --from=builder /home/idengine/bin/ /home/idengine/bin/
# Py wrapper
COPY --from=builder /home/idengine/bindings/python/pyidengine.py /home/idengine/bindings/python/pyidengine.py
# Bundle
COPY --from=builder /home/idengine/data-zip/ /home/idengine/data-zip/
# Server
COPY "./integration/docker/idengine_server.py" /home/idengine/

WORKDIR "/home/idengine/"

# --bundle_dir (required) - path to bundle.
# --lazy - IdEngine lazy mode. Not recommended for server.
# --concur - Concurrency. All CPU cores enabled by default.
# --port - Server port. [default 53000]

CMD ["sh","-c","/venv/bin/python3 idengine_server.py --bundle_dir './data-zip/'  "]