+++
title = "Docker"
description = "Containers with Docker."

[extra]
lang = "ENG"
+++

## Connect to hub.docker.com

```sh
  docker login --username <user>
```

## Connect to another website (UNSECURE way)

```sh
  TOKEN=<your website token>
  echo $TOKEN | docker login <url> -u <username> --password-stdin
```

### Build a docker image from a Dockerfile

```sh
  docker build -t <NAME>:<VERSION> -f <FILENAME> <PATH>
```

## Pull an image from hub.docker.com

```sh
  docker pull <image>:<tag>
```

## Pull an image from another website

```sh
  docker pull <website_url>/<image>:<tag>
```

## Push an image to hub.docker.com


```sh
  docker push <user>/<image>:tag
```

## Push an image to another website

```sh
  docker push <website_url>/<user>/<image>:<tag>
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
