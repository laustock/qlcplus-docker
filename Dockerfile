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

#FROM debian@sha256:382967fd7c35a0899ca3146b0b73d0791478fba2f71020c7aa8c27e3a4f26672

FROM elestio/docker-desktop-vnc@sha256:653ee84f42ea6d36cfc2f62ff02054f5fcd3eb77fac8bea9682b61b916dc589b

COPY qlcplus.sh /QLC/entrypoint.sh

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

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
               ${QLC_DEPENDS} 

ARG QLC_VERSION=4.13.1
ADD https://www.qlcplus.org/downloads/${QLC_VERSION}/qlcplus_${QLC_VERSION}_amd64.deb qlcplus.deb

RUN dpkg -i qlcplus.deb

EXPOSE 9999/tcp

VOLUME /QLC

ENTRYPOINT /bin/sh /QLC/entrypoint.sh

CMD /bin/bash
