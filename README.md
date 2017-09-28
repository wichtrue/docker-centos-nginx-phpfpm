<h2>docker-centos-nginx-phpfpm</h2>

#Build image <br> 
1. docker build -t container_image .<br>
#Create container<br>
2. docker run -name container_name -p 80:80 -v /var/www/html:/var/www/html <container_image> <br>
#Start Nginx <br>
3. docker exec -it container_name nginx <br>
