# official images
From ubuntu:20.04
From openjdk:11

# update the OS
RUN apt-get update  && apt-get upgrade -y

# install java
RUN apt-get install openjdk-11-jre-headless -y

# Install maintain packages
RUN apt-get install sudo net-tools iputils-ping nano vim cron curl wget -y

# install mysql-client
RUN apt-get install default-mysql-client libmariadb-dev-compat libmariadb-dev  -y


# first import the repo signing key:#
RUN curl -L https://packages.rundeck.com/pagerduty/rundeck/gpgkey | sudo apt-key add -

# Then let's add the sources list file of Rundeck /etc/apt/sources.list.d/rundeck.list
RUN echo 'deb https://packages.rundeck.com/pagerduty/rundeck/any/ any main' > /etc/apt/sources.list.d/rundeck.list
RUN echo 'deb-src https://packages.rundeck.com/pagerduty/rundeck/any/ any main' >>/etc/apt/sources.list.d/rundeck.list

# Update the cache of the repository
RUN apt-get update

# Now, install Rundeck using apt command, type
RUN apt-get install rundeck -y

# We need now to tell Rundeck how to connect the database. We will edit its configuration file with some updates. 
RUN sudo sed -e '/dataSource.url/s/^/#/' -i  /etc/rundeck/rundeck-config.properties
RUN sudo sed -e '/dataSource.dbCreate/s/^/#/' -i  /etc/rundeck/rundeck-config.properties
RUN sudo sed -i 's/localhost/135.148.234.145/' /etc/rundeck/rundeck-config.properties
RUN sudo sed '9 a dataSource.driverClassName=org.mariadb.jdbc.Driver' -i  /etc/rundeck/rundeck-config.properties
RUN sudo sed '10 a dataSource.url=jdbc:mysql://mydb/rundeck?autoReconnect=true&useSSL=false&allowPublicKeyRetrieval=true' -i  /etc/rundeck/rundeck-config.properties
RUN sudo sed '11 a dataSource.username=rundeckuser' -i  /etc/rundeck/rundeck-config.properties
RUN sudo sed '12 a dataSource.password=rundeckpassword' -i /etc/rundeck/rundeck-config.properties

#PORTS
EXPOSE 3306
EXPOSE 4440 
EXPOSE 4443

# check versions details
RUN java -version
RUN mariadb --version
RUN cat /etc/os-release
RUN mysql --version

# start rundeck
#CMD service rundeckd start
ENTRYPOINT service rundeckd start && bash
