+++
title = "GPG"
template = "data/page.html"
+++

### Lister les clefs

* Public :
```sh
  $ gpg --list-keys
```

* Secret :
```sh
 $ gpg --list-secret-keys
```

### Importer une clef
* Depuis un fichier :
```sh
 $ gpg --import <name>.key
```

* Depuis un serveur :
```sh
  $ gpg --keyserver <server> --search-keys <mail>
```

### Vérifier l'empreinte :
```sh
 $ gpg --fingerprint <mail>
 ```

### Signer la clef
```sh
 $ gpg --sign-key <mail>
```

### Rafraichir les clefs
```sh
 $ gpg --keyserver pgp.mit.edu --refresh-keys
```

### Partager sa clef public
* Par un fichier
```sh
 $ gpg --output <path/name>.key --armor --export <mail>
```

* Sur un serveur :
```sh
  $ gpg --send-keys --keyserver <server> <fingerprint>
```

### Générer un certificat de révocation
```sh
 $ gpg --output <path/name>.crt --gen-revoke <mail>
 $ chmod 600 <path/certificat>
```

### Révoquer sa clef
```sh
  $ gpg --import <certificat>
  $ gpg --keyserver pgp.mit.edu --search-keys key-ID
  $ gpg --keyserver pgp.mit.edu --send-keys key-ID
```

### Chiffrer
```sh
  $ gpg --encrypt --sign --armor -r <mail> <file>
```

### Déchiffrer
```sh
  $ gpg --decrypt <file> > <output>
```
