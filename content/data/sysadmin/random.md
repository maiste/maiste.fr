+++
title = "Random"
template = "data/page.html"
+++

## Backup

* rsync : utilitaire de backup
```sh
 # a is for archive, v for verbose, h for human and p for partial
 $ rsync -avhp src/ dest/
```


## Restriction des privilèges ssh

Utilisation de *chroot jail* avec SSH. Cela permet d'isoler le client dans
un dossier avec des commandes limitées.

Voir le lien suivant: [chroot jail](https://allanfeid.com/content/creating-chroot-jail-ssh-access)

## Bloquer les connexions sur le port 22:

Utilisation du logiciel endlessh
