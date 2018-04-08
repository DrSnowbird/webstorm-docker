FROM openkbs/jdk-mvn-py3-x11

MAINTAINER DrSnowbird "DrSnowbird@openkbs.org"

ARG INSTALL_DIR=${INSTALL_DIR:-/opt}

####
#### ---- Per product unique vars: change per product ----
## https://download.jetbrains.com/webstorm/WebStorm-2018.1.tar.gz
## ./WebStorm-181.4203.535/bin/webstorm.sh
ARG PRODUCT_VER=${PRODUCT_VER:-2018.1}
ARG PRODUCT_SHORT_VER=${PRODUCT_SHORT_VER:-181}
##
ARG PRODUCT_DOWNLOAD_ROOT=https://download.jetbrains.com
ARG PRODUCT_NAME=WebStorm
#ARG PRODUCT_NAME_LOWER="`echo $PRODUCT_NAME | tr '[:upper:]' '[:lower:]'`"
ARG PRODUCT_NAME_LOWER=webstorm
ARG PRODUCT_EXE_NAME=${PRODUCT_NAME_LOWER}.sh
####
#### ---- Mostly, generic: change only needed ----
ARG PRODUCT_TGZ=${PRODUCT_TGZ:-${PRODUCT_NAME}-${PRODUCT_VER}.tar.gz}
ARG PRODUCT_TGZ_URL=${PRODUCT_URL:-${PRODUCT_DOWNLOAD_ROOT}/${PRODUCT_NAME_LOWER}/${PRODUCT_TGZ}}
ARG PRODUCT_HOME=${PRODUCT_HOME:-${INSTALL_DIR}/${PRODUCT_NAME}-${PRODUCT_SHORT_VER}}
ARG PRODUCT_HOME_LINK=${PRODUCT_LINK:-${INSTALL_DIR}/${PRODUCT_NAME}}

ARG PRODUCT_EXE=${PRODUCT_HOME_LINK}/bin/${PRODUCT_EXE_NAME}
ENV PRODUCT_EXE=${PRODUCT_EXE}

############################# 
#### ---- Install Target ----
############################# 
WORKDIR ${INSTALL_DIR}

RUN wget -c ${PRODUCT_TGZ_URL} && \
    tar xvf ${PRODUCT_TGZ} &&\
    mv ${PRODUCT_HOME}* ${PRODUCT_HOME_LINK} && \
    rm ${PRODUCT_TGZ} && \
    echo " PRODUCT_HOME=$PRODUCT_HOME\n PRODUCT_EXE=$PRODUCT_EXE \n PRODUCT_HOME_LINK=$PRODUCT_HOME_LINK " && \
    ls -al $PRODUCT_HOME_LINK /usr/WebStorm 
    
## ---- user: developer ----
ENV USER_NAME=developer
ENV HOME=/home/${USER_NAME}

RUN mkdir -p ${HOME}/workspace ${HOME}/data && \
    chown -R ${USER_NAME}:${USER_NAME} ${HOME}/ && \
    ls -al ${PRODUCT_EXE}

VOLUME "${HOME}/data"
VOLUME "${HOME}/workspace"

WORKDIR ${HOME}/workspace
USER "${USER_NAME}"

ENTRYPOINT "${PRODUCT_EXE}"

#CMD ["/bin/bash"]
