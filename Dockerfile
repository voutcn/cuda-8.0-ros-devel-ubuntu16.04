FROM nvidia/cuda:8.0-cudnn7-devel-ubuntu16.04

# Set default shell to bash
SHELL ["/bin/bash", "-c"]

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

WORKDIR ${HOME}

RUN echo "Octopus Base Image Building Sequence Started..."

RUN echo "Preparing system environment..."

RUN mv /root/.bashrc /root/bashrc.bak && \
    touch /root/.bashrc

RUN apt-get update -qq > /dev/null && apt-get install -y -qq sudo wget lsb-release iputils-ping > /dev/null && \
    apt-get install -y -qq build-essential libopencv-dev python-opencv vim htop sshfs nfs-common python-dev git python-pip python-all-dev libatlas-base-dev gfortran > /dev/null && \
    apt-get install -y -qq libopenblas-dev mpg123 > /dev/null && \
    rm -rf /var/lib/apt/lists/*

RUN wget -q https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    export PATH=/usr/local/bin:$PATH && \
    rm get-pip.py

RUN pip install -q -U bitarray pyzmq ujson requests pymysql numpy pandas scipy scikit-learn gTTs awscli numba chardet > /dev/null

RUN echo "Installing ROS..."

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116 && \
    apt-get update -qq > /dev/null && \
    apt-get install -y -qq ros-kinetic-desktop-full > /dev/null && \
    apt-get install -y -qq ros-kinetic-nmea-msgs ros-kinetic-nmea-navsat-driver ros-kinetic-jsk-visualization ros-kinetic-slam-gmapping ros-kinetic-geodesy > /dev/null && \
    apt-get install -y -qq ros-kinetic-audio-capture > /dev/null && \
    apt-get install -y -qq libboost-all-dev cmake compiz-plugins compizconfig-settings-manager libpcap-dev libglew-dev > /dev/null && \
    rosdep init && \
    rosdep update && \
    echo "source /opt/ros/kinetic/setup.bash" >> /root/.bashrc && \
    source /root/.bashrc && \
    apt-get install -y -qq python-rosinstall > /dev/null && \
    apt-get install -y -qq pulseaudio socat alsa-utils ffmpeg gstreamer1.0* > /dev/null && \
    apt-get install -y -qq ros-kinetic-gazebo-ros-control; \
    apt-get install -y -qq ros-kinetic-controller-manager; \
    apt-get install -y -qq ros-kinetic-position-controllers; \
    apt-get install -y -qq ros-kinetic-transmission-interface; \
    apt-get install -y -qq v4l-utils; \
    apt-get install -y -qq ros-kinetic-velocity-controllers; \
    apt-get install -y -qq ros-kinetic-can-msgs; \
    apt-get install -y -qq ros-kinetic-control-toolbox ; \
    apt-get install -y -qq ros-kinetic-controller-interface; \
    apt-get install -y -qq ros-kinetic-controller-manager ; \
    apt-get install -y -qq ros-kinetic-controller-manager-msgs; \
    apt-get install -y -qq ros-kinetic-hardware-interface ; \
    apt-get install -y -qq ros-kinetic-joint-limits-interface; \
    apt-get install -y -qq ros-kinetic-realtime-tools ; \
    apt-get install -y -qq ros-kinetic-transmission-interface; \
    apt-get install -y -qq ros-kinetic-laser-proc ros-kinetic-urg-c; \
    apt-get install -y -qq bluez; \
    apt-get install -y -qq evemu-tools; \
    apt-get install -y -qq evtest; \
    apt-get install -y -qq inputattach; \
    apt-get install -y -qq joystick; \
    apt-get install -y -qq libbluetooth3; \
    apt-get install -y -qq libcwiid1; \
    apt-get install -y -qq libevemu3; \
    apt-get install -y -qq libspnav-dev; \
    apt-get install -y -qq libusb-dev; \
    apt-get install -y -qq python-bluez; \
    apt-get install -y -qq python-cwiid; \
    apt-get install -y -qq ros-kinetic-combined-robot-hw; \
    apt-get install -y -qq ros-kinetic-combined-robot-hw-tests; \
    apt-get install -y -qq ros-kinetic-controller-manager-tests; \
    apt-get install -y -qq ros-kinetic-diff-drive-controller; \
    apt-get install -y -qq ros-kinetic-effort-controllers; \
    apt-get install -y -qq ros-kinetic-force-torque-sensor-controller; \
    apt-get install -y -qq ros-kinetic-gripper-action-controller; \
    apt-get install -y -qq ros-kinetic-imu-sensor-controller; \
    apt-get install -y -qq ros-kinetic-joint-state-controller; \
    apt-get install -y -qq ros-kinetic-joint-trajectory-controller; \
    apt-get install -y -qq ros-kinetic-ps3joy; \
    apt-get install -y -qq ros-kinetic-rqt-joint-trajectory-controller; \
    apt-get install -y -qq ros-kinetic-spacenav-node; \
    apt-get install -y -qq ros-kinetic-wiimote; \
    apt-get install -y -qq spacenavd; \
    apt-get install -y -qq ros-kinetic-grid-map-core; \
    apt-get install -y -qq ros-kinetic-grid-map-cv; \
    apt-get install -y -qq ros-kinetic-grid-map-msgs; \
    apt-get install -y -qq ros-kinetic-grid-map-ros; \
    apt-get install -y -qq curl;

RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN apt-get install -y nodejs
RUN rm -rf /var/lib/apt/lists/*

RUN rosdep fix-permissions

RUN echo "US/Pacific" > /etc/timezone && \
    unlink /etc/localtime && \
    sudo ln -s /usr/share/zoneinfo/US/Pacific /etc/localtime

# Define default command.
CMD ["/bin/bash"]
