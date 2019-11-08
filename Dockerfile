# https://github.com/matterport/Mask_RCNN
# CUDA 8 +  CUDNN 6.0.21 + requirements.txt + tensorflow-gpu==1.4.0.
# docker build --network=host -t pollenm/deeplearning_mask_rcnn_master .

FROM nvidia/cuda:8.0-devel-ubuntu16.04
LABEL MAINTAINER Pollen Metrology <admin-team@pollen-metrology.com>

RUN apt-get update && apt-get install


# --------------------- START JENKINS ---------------------- #
# Config of Jenkins
ARG VERSION=3.28
ARG user=jenkins
ARG group=jenkins
ARG uid=2222

# Install Jenkins Slave
RUN apt-get install -y curl locales sudo && \
    curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar && \
    #apt-get purge --autoremove -y curl && \
    chmod 755 /usr/share/jenkins && \
    chmod 644 /usr/share/jenkins/slave.jar

# Add java for Jenkins Slave
RUN apt-get install -y --no-install-recommends default-jdk    

# Add user jenkins to the image
RUN adduser --system --quiet --uid ${uid} --group --disabled-login ${user}

# USER jenkins
RUN echo "${user} ALL = NOPASSWD : /usr/bin/apt-get" >> /etc/sudoers.d/jenkins-can-install 

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENV JENKINS_AGENT_WORKDIR=${AGENT_WORKDIR}
ENV JENKINS_AGENT_NAME "NOT SET"
ENV JENKINS_SECRET "NOT SET"
ENV JENKINS_URL "NOT SET"

COPY jenkins-slave.sh /usr/bin/jenkins-slave.sh
RUN chmod 777 /usr/bin/jenkins-slave.sh
# --------------------- END JENKINS ---------------------- #

RUN apt-get install -y wget

RUN wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/libcudnn6_6.0.21-1+cuda8.0_amd64.deb && dpkg -i libcudnn6_6.0.21-1+cuda8.0_amd64.deb

RUN apt-get install -y python-dev python3-pip

RUN pip3 install --upgrade pip

# Add tensorflow 1.4
RUN pip3 install tensorflow-gpu==1.4

# Add scikit
RUN pip3 install scikit-image

# Add imgaug
RUN pip3 install imgaug

# Add keras
#RUN pip3 install keras
RUN pip3 install --upgrade keras==2.0.8

# Add cython
RUN pip3 install cython

# Add opencv-python
RUN pip3 install opencv-python

# Add h5py
RUN pip3 install h5py

# Add ipython
RUN pip3 install ipython
RUN apt-get install libglib2.0-0
RUN apt-get install -y libsm6 libxext6 libxrender-dev

# pip3 install -r requirements.txt
# python3 setup.py install
# python3 Mask_RCNN_master/balloon.py train --dataset=Mask_RCNN_master/datasets/balloon/ --weights=coco

ENTRYPOINT ["/usr/bin/jenkins-slave.sh"]
