FROM mjmg/centos-supervisor-base:latest

# Instructions from https://msdn.microsoft.com/en-us/microsoft-r/rserver-install-linux-server

# Install OpenJDK8
RUN \
  yum install -y java-1.8.0-openjdk-headless make gcc gcc-c++ gfortran cairo-devel libicu libicu-devel nfs-utils nfs-utils-lib 
  
ENV JAVA_HOME=/usr/lib/jvm/jre-1.8.0

# en_microsoft_r_server_for_linux_x64_8944657.tar.gz must exist in root directory with Dockerfile
COPY en_microsoft_r_server_for_linux_x64_8944657.tar.gz /tmp/en_microsoft_r_server_for_linux_x64_8944657.tar.gz

RUN \
  cd /tmp && \
  tar -xvzf en_microsoft_r_server_for_linux_x64_8944657.tar.gz 
  
RUN \
  cd /tmp/MRS80LINUX && \
  ./install.sh -a -d -u  
RUN \  
  cd /tmp/MRS80LINUX/DeployR/ && \
  tar -xvzf DeployR-Enterprise-Linux-8.0.5.tar.gz
  #cd deployrInstall/installFiles
  #./installDeployREnterprise.sh
  
# Add default root password with password r00tpassw0rd
RUN \
  echo "root:r00tpassw0rd" | chpasswd  

# Add default RUser user with pass rstudio
RUN \
  useradd RUser && \
  echo "RUser:RUser" | chpasswd && \ 
  chmod -R +r /home/RUser 
  #chown -R RUser /usr/lib64/MRS80LINUX

RUN \
  yum install -y /tmp/MRS80LINUX/microsoft-r-server-mro-8.0/microsoft-r-server-mro-8.0.rpm \
                 /tmp/MRS80LINUX/RPM/microsoft-r-server-packages-8.0.rpm \
                 /tmp/MRS80LINUX/RPM/microsoft-r-server-intel-mkl-8.0.rpm
  
  
# default command
CMD ["/usr/bin/R"]
