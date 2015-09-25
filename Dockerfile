#
# MAINTAINER    xialingsc <xialingsc@gmail.com>
# DATE          2015-09-23
# DESCRIPTION   Dockerfile for building ubuntu-gap
#
#Set ubuntu14.04 for base image
FROM ubuntu:14.04
#creater xialingsc
MAINTAINER xialingsc <xialingsc@gmail.com>
#set sys date
ENV TZ "Asia/Shanghai"
#install base tool,such as passwd、
RUN apt-get install passwd openssl openssh-server -y
#modify passward of root
#there is some errorRUN echo 'workflow' | passwd --stdin root
RUN (echo 'workflow';sleep 1;echo 'workflow')| passwd  root
#create ssh key
#RUN ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N ''
#RUN ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''
#create /var/run/sshd,or occur no such file or directory
Run mkdir -p /var/run/sshd
#modify /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
#close default pam_loginuid.so
RUN sed -i '/^session\s\+required\s\+pam_loginuid.so/s/^/#/' /etc/pam.d/sshd
RUN mkdir -p /root/.ssh && chown root.root /root && chmod 700 /root/.ssh
EXPOSE 22
#set run cmd: print ip and start sshd by daemon style
CMD ip addr ls eth0 | awk '{print $2}' | egrep -o '([0-9]+\.){3}[0-9]+';/usr/sbin/sshd -D
#CMD /usr/sbin/sshd -D


