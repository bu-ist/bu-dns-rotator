# DNS rotator

[![Build Status](https://travis-ci.org/bu-ist/bu-dns-rotator.svg?branch=master)](https://travis-ci.org/bu-ist/bu-dns-rotator)

This docker image helps to change the IP address a hostname resolves to inside
Docker networks.


## Sample Usage

The example below assumes that you have a container (`app`) that needs to
resolve some [non-]existing hostname (`backend`) using the custom DNS server.

The IP it resolves to needs to be the IP of some existing container from the 
same network (`backend1` and `backend2`).

```
version: "3.4"

services:

  dns:
    image: bostonuniversity/dns-rotator:latest
    networks:
      frontend:
        ipv4_address: 10.6.0.10

  backend1:
    # This container is going to have a unique IP
    networks:
      frontend:

  backend2:
    # This container is going to have a unique IP
    networks:
      frontend:

  app:
    # This container needs to resolve the hostname "backend"
    networks:
      frontend:

networks:
  frontend:    
    driver: bridge
    ipam:
     config:
       - subnet: 10.6.0.0/16

```

While your containers are running, run this command:
```
docker-compose exec dns change-ip.sh backend backend1
```

When resolving the `backend` hostname inside the `app` container using the
`dns` container's IP as the dns server, you'll see that it points to the
IP of `backend1`:
```
$ docker-compose run --rm app nslookup backend 10.6.0.10

Server:         10.6.0.10
Address:        10.6.0.10#53

Name:   backend
Address: 10.6.0.11
```

You can continue switching to other backends:
```
docker-compose exec dns change-ip.sh backend backend2
```
