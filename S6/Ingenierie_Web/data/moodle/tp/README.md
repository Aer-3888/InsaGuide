# Ingenierie Web - TPs

INSA Rennes - 3rd Year Computer Science  
Web Engineering Course

## Lab Index

| TP | Directory | Topic | Technologies |
|----|-----------|-------|-------------|
| TP1 | [tp1_javascript](tp1_javascript/) | JavaScript Introduction | Vanilla JS, DOM, Canvas, ES6+, Babel |
| TP2 | [tp2_rest_api](tp2_rest_api/) | REST API Design & Implementation | JAX-RS (Jersey), Maven |
| TP3 | [tp3_data_formats](tp3_data_formats/) | XML & JSON Processing | XML, DTD, XSD, JSON, Jackson |
| TP4 | [tp4_orm_jpa](tp4_orm_jpa/) | ORM & Database Persistence | JPA, Hibernate |
| TP5 | [tp5_angular](tp5_angular/) | Angular SPA Framework | Angular 12, TypeScript, RxJS |

## Additional Resources

| Directory | Description |
|-----------|-------------|
| [tp_github_resources](tp_github_resources/) | Course GitHub repository with slides, examples, and GUIDE |
| [tp_legacy_2022](tp_legacy_2022/) | 2022 version: complete project (JS, JSON, ORM, REST, Spring) |

## TP Details

### TP1 - JavaScript Introduction
- Silly story generator (template strings, events)
- Image gallery (DOM manipulation)
- Bouncing balls animation (OOP, Canvas)
- ES6+ features with Babel transpilation (`es6_babel/`)

### TP2 - REST API
- REST principles, HTTP methods, API design (`sujet_rest.pdf`)
- **Jersey Calendar API** (`jersey_calendar_api/`): Academic calendar management with JAXB, Swagger
- **Jersey Example** (`jersey_example/`): Player card management API

### TP3 - Data Formats
- **XML** (`xml/`): XML syntax, DTD, XSD, Relax NG validation
- **JSON** (`json/`): JSON API, JavaScript & Java processing, Jackson/Gson

### TP4 - ORM (JPA)
- Entity mapping, relationships, JPQL queries, transactions

### TP5 - Angular
- Components, routing, services, HTTP client
- Player/Album management application (`tp-angular/`)

## Technology Stack

### Frontend
- HTML5, CSS3, JavaScript ES6+, Angular 12, TypeScript

### Backend
- Java 8+, JAX-RS (Jersey), Spring Boot 2.x, Maven

### Data
- JSON, XML, JAXB, Jackson, JPA/Hibernate

## Common Commands

```bash
# Java/Maven projects
mvn clean package
mvn test
mvn spring-boot:run

# Angular project
cd tp5_angular/tp-angular
npm install
ng serve    # http://localhost:4200

# JavaScript (Babel)
cd tp1_javascript/es6_babel
npm install
npm run build
```

## Setup Requirements

- Java 8+, Maven 3.6+
- Node.js 14+, npm 6+, Angular CLI
- curl or Postman for API testing

## Resources

- [JAX-RS (Jersey)](https://eclipse-ee4j.github.io/jersey/)
- [Spring Boot](https://spring.io/projects/spring-boot)
- [Angular](https://angular.io)
- [MDN Web Docs](https://developer.mozilla.org)
