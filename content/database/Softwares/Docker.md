+++
title="Docker"
description="TL;DR how to use docker"
+++

`WARNING: Todo tanslation`

## Se connecter à docker

```sh
	docker login --username <user>
```

## Pull une image

```sh
	docker pull <image>:<tag>
```

## Push une image


```sh
	docker push <user>:tag
```

## Lancer un conteneur

En intéractif:

```sh
	docker run -it --name <nom> -v <volume-local>:<volume-conteneur> <image>:<tag>
```

Comme un deamon:
```sh
	docker run --rm -d --name <nom> -v <volume-local>:<volume-conteneur> \
	-p <host-port>:<conteneur-port><image>:<tag>
```

## Se connecter à un conteneur
```sh
	docker exec -it <tag> <command>
```

## Avoir les logs d'un conteneur

```sh
	docker logs <name ou id>
```

## Stopper un conteneur

```sh
	docker stop <name>
```

## Faire une sauvegarde d'images

```sh
	docker commit -p <ID> tag_name
	docker save -o <name>.tar <tag_image>
```

## Charger un conteneur depuis une sauvegarde

```sh
	docker load -i <name>.tar
```

# Ressources

 - [Bonne pratique](https://github.com/hexops/dockerfile)
