---
id: rest
aliases: []
tags: []
description: Deal with REST in Java
language: fr
title: REST Api
---


### TL;DR

- Les __Data Transfert_Object__ sont utilisés en I/O. Permet de simplifier les échanges.


### DTO

C'est un objet qui permet de cacher au niveau de l'API le vrai contenu des entités. Ils sont gérés
par les _Controllers_. Un _DTO_ vient toujours avec un Mapper. Les `record` sont particulièrement adaptés à cela.

#### Example

- Entity:
```java
@Entity
public class Person {
    private String name;
    private String gender;
    private String address;

    /* Getters / Setters */
}
```
- DTO (souvent un record mais attention à la version de Spring):
```java
public record PersonDto(
    String name,
    String gender
) {}
```
- Mapper (soit un composant _Spring_, soit une classe "static"):
```java
@Component
public class PersonDtoMapper {
    public PersonDto fromModel(Person p) {
        return new PersonDto(
            p.getName(),
            p.getGender()
        );
    }
}

```

### JsonView (peu utilisé)

`@JsonView` définit un ensemble de propriétés qui seront exportées en _JSON_. On peut annoter les
propiétés avec une vue pour qu'elle soit associée à celle-ci. Quand un controller mapping est annoté
avec une `@JsonView`, il utilisera les gens qui fonctionnent pour produire la vue associé en _JSON_.
On peut utiliser l'héritage pour étendre le scoe des vues.

#### Example

- Entity:
```java
@JsonView(Views.LIGHT.class)
public class Person {
    @JsonView(View.ID.class)
    private Long id;

    private String name;
    private String gender;
    private String address;

    public static class Views {
        public interface ID {}
        public interface LIGHT extends ID {}
        public interface PAGE extends LIGHT {}
        public interface FULLL extends PAGE {}
    }
}
```
- Method call:
```java
@GetMapping
@JsonView(Person.Views.LIGHT.class)
public Page<Person> fetchPage() {
    return personService.findAll();
}
```

### JsonIdentity

#### JsonIdentityInfo

Permet de dédupliquer les champs envoyés:
```java
@JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "id")
public class Person { /* ... */}
```

#### JsonTypeInfo

Ajoute un field type pour les cas où il y a du polymorphisme. Cela permet de désérialiser dans le front.
- Par exemple, avec une classe mère:
```java
@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, defaultImpl = Product.class)
@JsonSubTypes({
        @JsonSubTypes.Type(value = Book.class),
        @JsonSubTypes.Type(value = VideoGame.class),
        @JsonSubTypes.Type(value = Phone.class)
})
public class Product { /* ... */ }

```

- Dans la classe fille:
```java
@JsonTypeName("book")
public class Book extends Product { /* ... */ }
```

### Resources & HTTP statuses

#### Status codes

- __2XX__
    - _200_ OK
    - _201_ CREATED
- __3XX__
- __4XX__:
    - __400__: Bad Request
    - __401__: Unauthorized
    - __403__: Forbidden
    - __404__: Not Found
    - __406__: Not acceptable
    - __409__: Conflict
    - __410__: Gone
- __5XX__:
    - __500__: Internal Server Error

#### In Spring

```java
@ResponseStatus(HttpStatus.status)
<type> <method_name>(){}
```

### Exception Handler

Cf [here](https://www.baeldung.com/exception-handling-for-rest-with-spring)

Possible de faire une entity pour renvoyer des erreurs. Ça permet de controller la granularité.

- Exception avec l'annotation `@ResponseStatus` sont retournés avec le bon http code.
- Exception Handler pour controlleur unique:
```java
public class Controller {
    @ExceptionHandler({ Exception1.class, Exception2.class})
    public void handler() {
        // Handle Here
    }
}
```
- `DefaultHandlerExceptionResolver` définit par défaut à partir de _Spring.3_
- `ResponseStatusExcetionREsolver`: permet de redéfinir avec un `@ResponseStatus` le code d'erreur des exceptions. Il faut que la classe avec le `@ResponseStatus` extends `RuntimeException`.
- `@ControllerAdvice` permet de faire un handler global:
```java
@ControllerAdvice
public class RestResponseEntityExceptionHandler 
  extends ResponseEntityExceptionHandler {

    @ExceptionHandler(value 
      = { IllegalArgumentException.class, IllegalStateException.class })
    protected ResponseEntity<Object> handleConflict(
      RuntimeException ex, WebRequest request) {
        String bodyOfResponse = "This should be application specific";
        return handleExceptionInternal(ex, bodyOfResponse, 
          new HttpHeaders(), HttpStatus.CONFLICT, request);
    }
}
```
- For REST use `@RestControllerAdvice` instead.

#### Reminder:

- DO:
    - If you need an error code/message, put it in the exception at the time you throw it
    - Use `@ControllerAdvice` or `@RestControllerAdvice` to handle all general purpose exceptions
    - Box all exceptions into a single `ApiException` with a uniformed shape

- DON'T:
    - Try-catch business-level exception everywhere in your controllers, to box them into `ApiException` with error message.
    - Write your own custom exception where `java.lang` or `java.util` has already a standard exception for the same purpose
      eg: Do not write `NotFoundException`, use java.util.NoSuchElementException.
    - Let your API output exceptions of various shape

### Hateoas

> HAL - Hypertext Application Language

- Import du package suivant:
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-hateoas</artifactId>
</dependency>
```
- Pour mettre un lien dans le header __location__, il faut modifier le code Java avec:
```java
    import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.linkTo;
    import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;
    
    public ResponseEntity<Customer> create(/* Args */) {
        Customer c = createCustomer();
        URI uri = linkTo(methodOn(CustomerApi.class).getCustomer(customer.getId())).toUri();
        return ResponseEntity.created(uri).body(customer);
    }
```
- Pour rajouter les liens dans le corps du _Json_, il faut utiliser:
```java
    public ResponseEntity<Customer> create(/* Args */) {
        Customer c = createCustomer();
        Link selfLink = linkTo(methodOn(CustomerApi.class).getCustomer(customer.getId())).withSelfRel();
        Link cartLink = linkTo(methodOn(CartApi.class).getCart(customer.getId(), customer.getCart().getId())).withRel("cart");
        return ResponseEntity.created(selfLink.toUri()).body(EntityModel.of(customer, selfLink, cartLink));
    }
```
- On peut utiliser le `RepresentationModelAssembler` pour créer les liens des entités automatiquement (comme les _serializers_ et les _generators_).

### OpenAPI (ex Swagger)

- To generate the _OpenAPI_ specification, we have to add the following packages:
```xml
<!-- Spring OpenAPI doc -->
<dependency>
    <groupId>org.springdoc</groupId>
    <artifactId>springdoc-openapi-ui</artifactId>
    <version>${springdoc.version}</version>
</dependency>
<!--support for hateoas -->
<dependency>
    <groupId>org.springdoc</groupId>
    <artifactId>springdoc-openapi-hateoas</artifactId>
    <version>${springdoc.version}</version>
</dependency>
<!-- support for Pageable-->
<dependency>
    <groupId>org.springdoc</groupId>
    <artifactId>springdoc-openapi-data-rest</artifactId>
    <version>${springdoc.version}</version>
</dependency>
```
- The Bean should be added to the configuration:
```java
OpenAPI openApi() {
    Contact contact = new Contact();
    contact.setName("Étienne Marais");
    contact.setEmail("emarais@takima.fr");
    return new OpenAPI().info(new Info()
        .contact(contact)
        .title("Takima-store Backend API")
        .license(new License().name("ISC")));
}
```
- The API is available on:
    - [Swagger-ui](http://localhost:8080/swagger-ui.html )
    - [JSON](http://localhost:8080/v3/api-docs)
    - [YAML](http://localhost:8080/v3/api-docs.yaml)
- These annotations can be used to be more user friendly:
    - `@Parameter`: 
    - `@Schema`: 
    - `@Content`:
    - `@Tag`: Marque une classe comme une ressource swagger
    - `@Operation`: Décrit une opération ou une méthode HTTP spécifique pour le chemin en question
    - `@ApiResponse`: Décrit une réponse possible à l'opération
