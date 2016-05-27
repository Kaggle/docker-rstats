FROM kaggle/rstats1

    # MXNet
RUN apt-get update && apt-get install -y libatlas-base-dev && \
    cd /usr/local/src && git clone --recursive https://github.com/dmlc/mxnet && \
    cd /usr/local/src/mxnet && cp make/config.mk . && \
    sed -i 's/ADD_LDFLAGS =/ADD_LDFLAGS = -lstdc++/' config.mk && \
    sed -i 's/USE_OPENCV = 1/USE_OPENCV = 0/' config.mk && \
    make all && make rpkg && R CMD INSTALL mxnet_*.tar.gz

    # IRKernel
ADD install_iR.R  /tmp/install_iR.R

RUN apt-get install -y libzmq3-dev && \
    Rscript /tmp/install_iR.R  && \
    apt-get install -y python-pip python-dev libcurl4-openssl-dev && \
    pip install jupyter pycurl && \
    R -e 'IRkernel::installspec()' && \
    yes | pip uninstall pyzmq && pip install --no-use-wheel pyzmq && \
# Make sure Jupyter won't try to "migrate" its junk in a read-only container
    mkdir -p /root/.jupyter/kernels && \
    cp -r /root/.local/share/jupyter/kernels/ir /root/.jupyter/kernels && \
    touch /root/.jupyter/jupyter_nbconvert_config.py && touch /root/.jupyter/migrated

CMD ["R"]


