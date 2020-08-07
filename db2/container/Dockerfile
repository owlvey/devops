# https://community.ibm.com/HigherLogic/System/DownloadDocumentFile.ashx?DocumentFileKey=789ec47e-7d7c-f5af-6ce9-7dcf00229be1
# https://epwt-www.mybluemix.net/software/support/trial/cst/programwebsite.wss?siteId=834&h=null&tabId=
FROM ubuntu
RUN apt-get update
RUN apt-get update && apt-get install -y apt-transport-https
RUN apt-get -y install ca-certificates
RUN apt-get -y install curl
RUN apt-get -y install software-properties-common
RUN apt-get install -y libaio1
RUN apt-get install -y binutils
RUN apt-get install -y zlib1g-dev
RUN apt-get install -y liblogger-syslog-perl
RUN apt-get install -y libpam0g:i386
RUN apt-get install -y libstdc++6
RUN apt-get install -y libx32stdc++6
RUN apt-get update
RUN mkdir /home/software
RUN mkdir /home/database
RUN chmod 777 /home/software
COPY ./v11.5.4_linuxx64_server_dec.tar.gz /home/software
WORKDIR /home/software
RUN gunzip *.gz
RUN tar -xvf v11.5.4_linuxx64_server_dec.tar
RUN rm -f v*.tar
RUN mv server_dec ibm-db2
RUN chmod 777 ibm-db2






RUN groupadd db2iadm1
RUN useradd -g db2iadm1 -m -d /home/db2inst1 -s /bin/bash db2inst1
RUN echo 'db2inst1:admin123' | chpasswd
RUN mkdir /home/software
RUN mkdir /home/software/Db2
RUN chmod 777 /home/software/Db2

 