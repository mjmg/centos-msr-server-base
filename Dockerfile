FROM mjmg/centos-supervisor-base:latest

# Instructions from https://msdn.microsoft.com/en-us/microsoft-r/rserver-install-linux-server

# Install OpenJDK8 and other prerequisites
#RUN \
#  yum update -y && \
#  yum install -y java-1.8.0-openjdk-headless make gcc gcc-c++ gfortran cairo-devel libicu libicu-devel nfs-utils nfs-utils-lib 
  
#ENV JAVA_HOME=/usr/lib/jvm/jre-1.8.0

# en_r_server_901_for_linux_x64_9648602.tar.gz must exist in root directory with Dockerfile
COPY en_r_server_901_for_linux_x64_9648602.tar.gz /tmp/en_r_server_901_for_linux_x64_9648602.tar.gz

RUN \
  cd /tmp && \
  tar -xvzf en_r_server_901_for_linux_x64_9648602.tar.gz
  
RUN \
  cd /tmp/MRS90Linux && \
  ./install.sh -a  

# Add default root password with password r00tpassw0rd
RUN \
  echo "root:r00tpassw0rd" | chpasswd  

# Add default RUser user with pass RUser
RUN \
  useradd RUser && \
  echo "RUser:RUser" | chpasswd && \ 
  chmod -R +r /home/RUser 

# Add default deployr-user user with pass deployr-pass
RUN \
  useradd deployr-user && \
  echo "deployr-user:deployr-pass" | chpasswd && \ 
  chmod -R +r /home/deployr-user 

RUN \
  cd /usr/lib64 && \
  ln -s libpcre.so.1 libpcre.so.0 && \
  ln -s libicui18n.so.50 libicui18n.so.36 && \
  ln -s libicuuc.so.50 libicuuc.so.36 && \
  ln -s libicudata.so.50 libicudata.so.36

EXPOSE 12800 12805 9054

# default command
CMD ["/bin/bash"]
