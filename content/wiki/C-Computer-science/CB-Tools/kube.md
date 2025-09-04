---
id: kube
aliases: []
tags: []
description: Comment faire tourner un cluster kube
lang: FR
title: Kubernetes
---

### Concepts

#### Terminologie

- _Infrastructure As Code_: management et provisionnement d'infrastructures via du code.
- _APM_: Application Performant Manager: monitorer et manager les performances et la disponibilité d'un service.
- Containers:
    - `Containers Runtime Low Level`: permettent l'execution de conteneur au format OCI
    - `Container Runtime High Level`: transport d'image
- Pour _Kubernetes_, tout est __resources__:
    - `Pod`: c'est la ressources minimale que l'on peut déployer dans _Kubernetes_. C'est un groupe d'un ou plusieurs containers qui partagent du stockage et un réseau.
    - _ReplicaSet_: permet de gérer la replication des _Pods_
    - _Deployment_: _ReplicaSet_ mais avec la gestion du cycle de vie en plus.
        - `Utilise la méthode du _RollingUpgrade_ pour migrer les pods vers une nouvelle version.
    - _Namespace_: permet de séparer les ressources de Kubernetes
    - _Node_:
        - _Worker Node_: est équivalent à un serveur. Contient un un _kubelet_ qui intéragit avec le _container runtime_.
        - `Master / Controller Node` s'occupe de gérer les `worker nodes`.
            - `etcd`: la base de données kube. Permet de synchroniser les noeuds.
            - `Controller manager` : s'occupe de discuter avec l'API
            - `Scheduler`: organise les nodes
            - `Kube Api`: discute avec le _kubelet_.
- Deux façons de faire:
    - déclarative (méthode préférée): on explique l'état auquel on veut arriver.
    - impérative: elle exécute ce qu'on lui demande.

### ReplicaSet

```yaml
kind: ReplicaSet
metadata:
  name: unicorn-front-replicaset
  labels:
    app: unicorn-front
spec:
  template:
    metadata:
      name: unicorn-front-pod
      labels:
        app: unicorn-front
    spec:
      containers:
      - name: unicorn-front
        image: registry.takima.io/school/proxy/nginx
  replicas: 3
  selector:
    matchLabels:
      app: unicorn-front
```

- Le `selector.matchLabels` doit matcher le label de la `spec` pour pouvoir gérer les replicas. Le nom du pod dans `template.metadata.name` est override par `metadata.name`.
- Dans le cas où on delete un `ReplicaSet`, on delete tous ses pods.

### Déploiement

#### Control des ressources

```yaml
resources:
  requests:
    memory: "64Mi"
    cpu: "250m"
  limits:
    memory: "128Mi"
    cpu: "500m"
```
- Dans `spec.container`, cela permet de gérer les ressources pour le cluster. `requests` correspond aux ressources nécessaires pour setup le pod. Cela permet de ne pas le scheduler dans un pod qui n'a pas les ressoruces nécessaire. `limit` correspond à la ressource max que le container peut utiliser.
- En cas d'erreur de mémoire, on obtient :
```sh
 Last State:     Terminated
      Reason:       OOMKilled
```
- Le controle CPU s'assure que la consommation ne dépasse pas. Il bloque en dessous de la limit.

### Services

Il agit comme un _load balancer_ en transmettant les requêtes aux pods auxquels il est rattaché.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: unicorn-front-service
spec:
  selector:
    app: unicorn-front
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```
-  `spec.ports.port` est le port sur lequel le service écoute et `spec.ports.targetPort` est le port exposé par le container. On peut utiliser les noms définis dans `spec.template.spec.containers[].ports[].name`.
- Par défaut le service fonctionne en `ClusterIp`, ce qui fait qu'il est accessible que depuis l'intérieur du cluster. Pour pallier au problème d'exposition, on peut faire une _NodePort_ qui expose l'ensemble des services ou _LoadBalancer_ pour provisionner un load balancer
- On peut aussi faire un _Ingress_ qui agit comme un reverse proxy.

### Ingress

C'est un peu un load balancer pour le service.
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
 annotations:
   kubernetes.io/ingress.class: nginx
 name: unicorn-front-ingress
spec:
 rules:
 - host: replace-with-your-url
   http:
     paths:
     - backend:
         service:
           name: unicorn-front-service
           port:
             number: 80
       path: /
       pathType: Prefix
```
-  Le CertManager permet aux utilisateur de créer un Ingress en demandant l'utilisation d'un cluster-issuer de certificat.

### CertManager

Il faut rajouter les paramètres suivants et avoir un `cluster-issuer` à disposition dans le cluster.
```yaml
# metadata:
#  annotations:
#    kubernetes.io/ingress.class: nginx
     cert-manager.io/cluster-issuer: letsencrypt-staging
     kubernetes.io/tls-acme: 'true'

# [...]
# spec:
#   rules:
    tls:
      - hosts:
        - replace-with-your-url
        secretName: unicorn-front-tls
```
- Si on a besoin d'un certificat `Wildcart`, il faut enlever `cert-manager.io/cluster-issuer` et `kubernetes.io/tls-acme` et utiliser le `secretName` pour avoir le bon certificat stocké dans les secrets.

### Registry privé

- Pour utiliser les registry privés, bien souvent, il faut setup les accès. Pour ce faire on crée un secret de type `docker-registry`.

```yaml
# spec:
#   template:
#     spec:
imagePullSecrets:
  - name: takima-school-registry
```

### Variable d'env

On peut ajouter des variables d'environnement

```yaml
# spec:
#   template:
#     spec:
#       container:
#         - name:
#           env:
- name: K8S_NODE_NAME
  valueFrom:
    fieldRef:
      fieldPath: spec.nodeName
```

### ConfigMap

Le _ConfigMap_ stocke les données non-confidentielles. On enregistre les données comme suit:
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: web-app
data:
  # property-like keys; each key maps to a simple value
  color: "#220"
```
On récupère les données comme suit dans le _deployment_.
```yaml
env:
  - name: CUSTOM_COLOR # Vrai key de la variable d'env. Peut être différent de la valeur dans le config map
    valueFrom:
      configMapKeyRef:
        name: web-app  # Nom du configmap
        key: color     # nom de la clef dans le config map
```

/!\ Il faut penser à restart !

### Secret

Pour les données confidentielles, on utilise les secrets de deux façons:
1) `kubectl create secret generic my-secret --from-literal=username=user`: on peut mettre plusieur littérals à la suite
2) Via le `yaml`:
- On doit générer le hash nous même
```sh
echo -n 'user' | base64
echo -n 'test123*' | base64
```
- Puis l'ajouter au yaml
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: hello-secret
type: Opaque
data:
  username: YWRtaW4=
  password: MWYyZDFlMmU2N2Rm
```

On peut ensuite l'utiliser avec:
```yaml
# container.[].env
- name: CUSTOM_COLOR
  valueFrom:
    secretKeyRef:
      name: secret-color
      key: color     # nom de la clef dans le config map
```

/!\ Dans lens, il est en __base64__, il faut penser à le __convertir__.

### Checkhealth

 Permet d'appeler un endpoint réguliérement pour vérifier qu'il est sein.

```yaml
# container.[]
livenessProbe:
  httpGet:
    path: /health
    port: 3000
    # httpHeaders:
    # - name: Custom-Header
    #   value: Awesome
  initialDelaySeconds: 1 # Initial check
  failureThreshold: 5 # Nombre de tentatives
  periodSeconds: 3   # Timing pour les checks
```

### HorizontalPodAutoscaler: mise à l'échelle automatique

Peut être créer en utilisant le `-o yaml` de `autoscale`.

### NetworkPolicy

Permet de contrôler les flux entre les pods.

### Redirection interne

Pour accèder à un service depuis un autre service, on peut utiliser le DNS interne. Pour un service `api` dans le namespace `test`, on peut appeler
`http://api.test`. S'ils sont dans le même namespace, on peut juste utiliser le nom du service: `http://api`.

### Persistence Volume

Cela correspond à l'abstraction du volume physique mappé sur les serveurs. Il s'agit d'une resources. Les _Persistence Volume Claims_ sont une demande de stockage par l'utilisateur. On peut définir différents types de stockages avec les _StorageClass_. Les volumes peuvent être statiques ou dynamiques.

- On peut définir un système de stockage comme suit:
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pg-pvc
spec:
  storageClassName: gp2
  accessModes:
  - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 3Gi
```
- Pour déclarer le bloc, il faut faire:
```yaml
# spec:
#   template:
#       spec:
volumes:
- name: pg-data
  persistentVolumeClaim:
    claimName: pg-pvc
```
- Pour le monter sur un container:
```yaml
# spec:
#   template:
#     spec:
#       container:
volumeMounts:
- mountPath: /var/lib/postgresql/data
  name: pg-data
```

### StatefulSet

Cela permet de scaler les ressources utilisées par un pod. Cependant, ça casse le fonctionnement du DNS.
```yaml
# kind: StatefulSet
# spec:
  serviceName: pg-service
  volumeClaimTemplates:
  - metadata:
      name: pg-data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi
```

Il faut modifier le lien d'accès car le load balancer ne fonctionne plus. On doit pointer vers `pod.service` au lieu de `service`.

### CronJob

Ressource qui permet de faire des jobs en fond à intervalle régulier.

### Operators

Cela correspond à une resource personalisée. On peut le faire grâce à une _Custom Resource Definition_.

### Helm

Helm est le "package manager" de Kubernetes. Il permet de faire des templates de toutes les ressources yaml d’une application donnée et les déployer sur Kubernetes. On peut déployer des stacks applicatives directement.

La stack applicative s'appelle une __Chart Helm__. On utilise les _values_ pour faire des _templates_ helm. On peut utiliser un système de variables grâce à _templates/_helpers.tpl_ (il s'agit de templates Go).

### Argo CD

Permet de faire du _GitOps_ en faisant le lien entre l'_Infra-As-Code_ et l'_Infrastructure_.

### Cheatsheet

- `kubectl`:
    - `config`: permet modifier et de visualiser la configuration.
        - `view`: affiche la configuration
        - `current-context`: affiche le contexte courant
    - `get`:
        - `pods`:
            - `<name>`: permet d'afficher un pod en particulier
            - `-n <namespace>`: afficher les pods gérés dans le contexte courant
        - `replicasets`: affiche les replicaSet disponible
        - `deployements`: affiche les deployements
        - `secrets`: permet de récupérer les secrets
        - `all`: affiche tout
    - `apply`: appliquer une spécification yaml sur un cluster et mettre à jour les changements
        - `-f <yaml spec>`: utiliser une specification yaml
    - `create`: créer une ressource
        - `-f <yaml spec>`: utiliser une specification
        - `-o yaml`: permet d'export au format yaml
        - `--dry-run=client`: peut être combiner avec `-o` pour produire les yaml en sortie.
        - `secret`: permet de faire des secrets
            - `docker-registry`: type de secret spécial pour les registry
                - `<secret name>`:
                - `--docker-server=<registry.gitlab.com>`: l'adresse du registry
                - `--docker-username=<readregcred>`: le username du registry
                - `--docker-password=<mdp>`: le mot de passe du registry
            - `generic`:
                - `<secret name>`
                - `--from-literal=key=value`: créer un secret à partir du key/value
    - `run`: start a container
        - `<pod name>`: the name of the pod
        - `--image <image docker>`: image à consommer
    - `delete`: suppression d'un pod
        - `pods`
            - `<pod name>`: nom du pod à supprimer
        - `replicasets`:
            - `<replica name>`: nom du replicaSet à supprimer
        - `deployements`:
            - `<deployement name>`: nom du deployement
    - `exec`: executer une commande sur un _pod_
        - `<pod name>`: le nom du pod
        - `-it <cmdline>`: executer une commande en particulier 
    - `logs`: afficher les logs d'un pod
        - `<pod name>`: le nom du pod
        - `-f`: suivre les logs
    - `set`:
        - `<deployement spec>`: ressource à modifier
        - `image`: modification sur l'image
    - `describe`: decrit la configuration
        - `deployements`: pour les déployements
        - `hpa`: horizontal scale
    - `edit`:
        - `<deployement name>`: the name of the deployement to edit
    - `rollout`:
        - `status`:
            - `deployment/<name>`
        - `history`: affiche l'historique des versions
            - `deployment/<name>`
            - `--revision=<number>`: afficher une révision en particulier
        - `pause:
            - `deployement/<name>`: met le déploiement en pause
        - `resume`:
            - `deployement/<name>`: relance un déploiement mis en pause
        - `undo`:
            - `deployment/<name>`
            - `--to-revision=<number>`: revient à une révision en particulier. Si non spécifié, revient à la version précédente.
        - `restart`: restart something
    - `scale`:
        - `<deployement name>`: nom du deploiement
        - `--replicas=<number>`: changer le nombre de replica.
    - `top`: affiche les ressources
        - `pod`:
            - `<pod name>`: affiche les ressources du pod en question.
    - `api-resources`: affiche toutes les resources utilisables par l'api
    - `autoscale`: permettre d'autoscale
        - `deployment`: type sur lequel ça s'applique
            - `<name>`: le nom
            - `--cpu-percent=50`: condition pour laquelle le CPU spawn un nouveau
            - `--min=1`: minimum pods
            - `--max=10`: maximum pods

- `helm`:
    - `template`: genère le template
        - `--values | -f`: le fichier _values_ utiliser. Ils sont lus dans l'ordre et s'il y a plusieurs fichiers, ils sont merged.
        - `--output-dir <dir>`: export les templates vers un dossier spécifique.
    - `install`: permet de créer le fichier et de déployer les resources.
        - `--dry-run`: n'effectue pas les actions.
        - `--debug`: affiche les actions effectuées.
        - 1.`<name>`: spécifie le nom.
        - 2.`<dir>`: spécifie le dossier où il y a les templates.

- `argocd`:
    - `cluster`: work on the cluster
        - `add`: ajouter
            `service-account@cluster-host`:  le cluster en question
    - `proj`:
        - `create`:
            - `<proj name>`: ensemble d'applicatif
    - `create`:
        - `<appname>`: lien entre `helm` et son `values`.
