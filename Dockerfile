ARG BASE_TAG=latest
ARG PYTHON_VERSION=3.11

FROM gcr.io/kaggle-images/rcran:${BASE_TAG}

ADD clean-layer.sh  /tmp/clean-layer.sh

# Install Python 
# TODO(philmod): is this necessary? try to remove!
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:deadsnakes/ppa -y
RUN apt update -y
RUN apt install python${PYTHON_VERSION} -y
RUN ln -sf /usr/bin/python${PYTHON_VERSION} /usr/bin/python
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python get-pip.py

RUN apt-get update && \
    apt-get install -y libzmq3-dev default-jdk && \
    apt-get install -y python${PYTHON_VERSION}-dev libcurl4-openssl-dev libssl-dev && \
    pip install jupyter pycurl && \
    # Install older tornado - https://github.com/jupyter/notebook/issues/4437
    pip install "tornado<6" && \
    pip install notebook && \
    pip install nbconvert && \
    R -e 'IRkernel::installspec()' && \
    # Build pyzmq from source instead of using a pre-built binary.
    yes | pip uninstall pyzmq && \
    pip install pyzmq --no-binary pyzmq && \
    cp -r /root/.local/share/jupyter/kernels/ir /usr/local/share/jupyter/kernels && \
    # Make sure Jupyter won't try to "migrate" its junk in a read-only container
    mkdir -p /root/.jupyter/kernels && \
    cp -r /root/.local/share/jupyter/kernels/ir /root/.jupyter/kernels && \
    touch /root/.jupyter/jupyter_nbconvert_config.py && touch /root/.jupyter/migrated && \
    # papermill can replace nbconvert for executing notebooks
    pip install papermill && \
    # b/276358430 fix Jupyter lsp freezing up the jupyter server
    pip install jupyterlab-lsp "jupyter-lsp==1.5.1" && \
    /tmp/clean-layer.sh

# Miniconda
RUN R -e 'reticulate::install_python(version = "${PYTHON_VERSION}:latest", force = TRUE)'
RUN R -e 'reticulate::virtualenv_create("r-reticulate")'

# RUN R -e 'reticulate::install_miniconda(update = TRUE, force = TRUE)'
# ENV RETICULATE_PYTHON=/root/.local/share/r-miniconda/envs/r-reticulate/bin/python

# Tensorflow and Keras
RUN R -e 'keras::install_keras(tensorflow = "default", extra_packages = c("pandas", "numpy", "pycryptodome"), method="auto", envname="r-reticulate")'

# Install kaggle libraries.
# Do this at the end to avoid rebuilding everything when any change is made.
ADD kaggle/ /kaggle/
# RProfile sources files from /kaggle/ so ensure this runs after ADDing it.
ENV R_HOME=/usr/local/lib/R
ADD RProfile.R /usr/local/lib/R/etc/Rprofile.site
ADD install_iR.R  /tmp/install_iR.R
ADD bioconductor_installs.R /tmp/bioconductor_installs.R
ADD package_installs.R /tmp/package_installs.R
ADD nbconvert-extensions.tpl /opt/kaggle/nbconvert-extensions.tpl
ADD kaggle/template_conf.json /opt/kaggle/conf.json
# Install with `--vanilla` flag to avoid conflict. https://support.bioconductor.org/p/57187/
RUN Rscript --vanilla /tmp/package_installs.R
RUN Rscript --vanilla /tmp/bioconductor_installs.R
RUN Rscript --vanilla /tmp/install_iR.R

ARG GIT_COMMIT=unknown
ARG BUILD_DATE_RSTATS=unknown

LABEL git-commit=$GIT_COMMIT
LABEL build-date=$BUILD_DATE_RSTATS

# Find the current release git hash & build date inside the kernel editor.
RUN echo "$GIT_COMMIT" > /etc/git_commit && echo "$BUILD_DATE_RSTATS" > /etc/build_date

CMD ["R"]
