#Author: Laurenz Stockhamer
#
#At first this is no professional dockerfile, because I am no expert in makeing dockerfiles so be pls be nice.
#
#This is a dockerfile to make a docker image that runs QLC+ in it.
#
#QLC+ is a open-source light control application for more see https://qlcplus.org/.
#
#The image which will be made with this dockerfile will open and start the project which you can bind it at the volume /QLC/qlc.qxw
#it will also will start the web application on the port 9999.
#
#Also make sure that you bind all ports out of the container you need for your communication to your lights, controller, etc.
#
#Also make sure when you build this dockerfile to a image that the qlcplus.sh file is in the same dir. .
#
#To build this dockerfile:
#-open a console and go to the dir where you downloaded the files
#-then run this command sudo docker image build -t name-you-want-for-this-image .
#-do not forget the point on the end of the command
#-now you have installed this image on machine and can create a container!

#base-image
FROM alpine@sha256:b93f4f6834d5c6849d859a4c07cc88f5a7d8ce5fb8d2e72940d8edd8be343c04
USER root

#copy start script
COPY qlcplus.sh /QLC/docker-entrypoint.sh

#installing lxde as desktop env
RUN apk update && apk upgrade
RUN apk add --allow-untrusted sudo xfce4 xfce4-terminal xrdp xorgxrdp iputils-ping apt dpkg bash
RUN setup-user -a admin -p $(openssl passwd 1234)
RUN adduser admin wheel

#Download the required pckgs for QLC+ and QLC+ itself
ENV QLC_DEPENDS="\
                libasound2 \
                libfftw3-double3 \
                libftdi1-2 \
                libqt5core5a \
                libqt5gui5 \
                libqt5multimedia5 \
                libqt5multimediawidgets5 \
                libqt5network5 \
                libqt5script5 \
                libqt5widgets5 \
                libqt5serialport5 \
                libusb-1.0-0\
                libxcb-cursor0\
                libxcb-xinerama0" 

RUN apt install -y ${QLC_DEPENDS} 
RUN apt clean

ARG QLC_VERSION=4.13.1
ADD https://www.qlcplus.org/downloads/${QLC_VERSION}/qlcplus_${QLC_VERSION}_amd64.deb qlcplus.deb

#installing QLC+
RUN dpkg -i qlcplus.deb

#exposing the ports you need to acces into the container
EXPOSE 9999
EXPOSE 3389

#execute start script
ENTRYPOINT ["bash", "/QLC/docker-entrypoint.sh"]
