Build the image
`sudo docker build -t xaryna/alpine-apache-php-mailpit .`

Docker Compose
```
    services:
      web:
        image: xaryna/alpine-apache-php-mailpit
        restart: always
        ports:
          - "1880:80"
          #- "1443:443"
        volumes:
          - /home/debian/docker/data/app/first-app/app:/htdocs
```
