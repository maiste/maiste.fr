+++
title = "GPG"
description = "Safe data with encryption."
template = "data/page.html"

[extra]
lang = "ENG"
+++

### List keys

* Public:
```sh
  gpg --list-keys
```

* Secret:
```sh
  gpg --list-secret-keys
```

### Import a key

* From a file:
```sh
  gpg --import <name>.key
```

* From a server:
```sh
  gpg --keyserver <server> --search-keys <mail>
```

### Export a key

```sh
  gpg --armor --export [key_id]
```

### Check footprint

```sh
  gpg --fingerprint <mail>
```

### Sign with a key

```sh
  gpg --sign-key <mail>
```

### Refresh a key server

```sh
  gpg --keyserver pgp.mit.edu --refresh-keys
```

### Share your public key

* With a file:
```sh
  gpg --output <path/name>.key --armor --export <mail>
```

* On a server:
```sh
  gpg --send-keys --keyserver <server> <fingerprint>
```

### Generate a revocation certificat

```sh
  gpg --output <path/name>.crt --gen-revoke <mail>
  chmod 600 <path/certificat>
```

### Revoke your key

```sh
  gpg --import <certificat>
  gpg --keyserver pgp.mit.edu --search-keys key-ID
  gpg --keyserver pgp.mit.edu --send-keys key-ID
```

### Encrypt a file

```sh
  gpg --encrypt --sign --armor -r <mail> <file>
```

### Decrypt a file

```sh
  gpg --decrypt <file> > <output>
```
