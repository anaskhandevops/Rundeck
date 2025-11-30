#### Create Network

    docker network create mynet
   
#### RUN Database(MySQL) container .
    
    docker run --name mydb --network mynet -e MYSQL_ROOT_PASSWORD=rundeckpassword -e MYSQL_USER=rundeckuser -e  MYSQL_PASSWORD=rundeckpassword -v /home/anas/rundeck/dbdata:/var/lib/mysql -d mysql:latest

##### Exec in DB container

     docker exec -it mydb mysql -u root -p
     create database rundeck;
     grant all privileges on *.* to 'rundeckuser'@'%';
     flush privileges;
     exit;
     
 #### Build Rundeck Image
      
      docker build -t rundeck .
      
#### RUN Rundeck container
      
     docker run -it -p3306:3306 -p4440:4440 --network=mynet --name myrundeck -d rundeck:latest
     
#### Browse

     http://your-ip:4440  

#### Credentials
     
     admin:admin
