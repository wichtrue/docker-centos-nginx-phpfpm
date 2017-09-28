docker-centos-nginx-phpfpm

#Build image
1. docker build -t <container_image> .

#Create container
2. docker run -name <container_name> -p 80:80 -v /var/www/html:/var/www/html <container_image>

#Start Nginx
3. docker exec -it <container_name> nginx
