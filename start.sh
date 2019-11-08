#!/bin/bash
# docker run -it -d --gpus all --name "deeplearning_mask_rcnn_master" -v /home/docker/deeplearning_mask_rcnn_master/jenkins_agent/ws:/home/jenkins pollenm/deeplearning_mask_rcnn_master

docker run \
  -e JENKINS_URL=https://jenkins.pollen-metrology.com/ \
  -e JENKINS_SECRET=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX \
  -e JENKINS_AGENT_WORKDIR=/home/jenkins \
  -e JENKINS_NAME=Deep_Learning_mask_rcnn_master \
  -it \
  -d \
  --gpus all \
  --name "deeplearning_mask_rcnn_master" \
  --restart always \
  -v /home/docker/deeplearning_mask_rcnn_master/jenkins_agent/ws:/home/jenkins \
  -v /home/deeplearning_script/:/home/scripts/ \
  pollenm/deeplearning_mask_rcnn_master
