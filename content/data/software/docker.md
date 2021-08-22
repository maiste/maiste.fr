+++
title = "Docker"
description = "Containers with Docker."
template = "data/page.html"

[extra]
lang = "ENG"
+++

## Connect to Hubdocker

```sh
  docker login --username <user>
```

## Pull an image

```sh
  docker pull <image>:<tag>
```

## Push an image


```sh
  docker push <user>:tag
```

## Launch a container

* Intractif mode:
```sh
  docker run -it --name <nom> -v <volume-local>:<volume-conteneur> \
             <image>:<tag>
```

* Deamon mode:
```sh
  docker run --rm -d --name <nom> -v <volume-local>:<volume-conteneur> \
             -p <host-port>:<conteneur-port><image>:<tag>
```

## Connect to a running container

```sh
	docker exec -it <tag> <command>
```

## Get the container logs

```sh
  docker logs <name ou id>
```

## Stop a containeur

```sh
  docker stop <name>
```

## Save docker images

```sh
  docker commit -p <ID> tag_name
  docker save -o <name>.tar <tag_image>
```

## Load a container from a save

```sh
  docker load -i <name>.tar
```

# Resources

 - [Good practises](https://github.com/hexops/dockerfile)
