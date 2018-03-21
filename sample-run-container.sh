#!/bin/bash

# arquivo de exemplo para iniciar o container
#export SOURCE_DIR='/home/appcivico/projects/De-Olho-Nas-Metas-2017'
export SOURCE_DIR='/home/votolegal/projects/votolegal-api'
export DATA_DIR='/tmp/votolegal/data/'

mkdir -p $DATA_DIR

# confira o seu ip usando ifconfig docker0|grep 'inet addr:'
export DOCKER_LAN_IP=172.17.0.1

# porta que será feito o bind
export LISTEN_PORT=8192

docker run --name votolegal \
 -v $SOURCE_DIR:/src -v $DATA_DIR:/data \
 -p $DOCKER_LAN_IP:$LISTEN_PORT:8080 \
 --cpu-shares=512 \
 --memory 1800m -d --restart unless-stopped appcivico/votolegal

