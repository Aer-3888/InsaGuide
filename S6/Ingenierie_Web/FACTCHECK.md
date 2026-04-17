# Fact-Check Report: S6 Ingenierie Web

**Date**: 2026-04-17
**Files reviewed**: 16 generated files (8 guide, 5 exercises, 1 exam-prep, 2 READMEs)
**Source files checked**: 25+ Java/JS/HTML source files from data/moodle/tp/

---

## Summary

Overall quality: GOOD. The generated guide is pedagogically sound and technically accurate on the core concepts. Most code examples are correct or faithful adaptations of the source material. A handful of transcription inaccuracies were found when comparing TP exercise code against actual source files, plus one misleading comment. All issues identified have been fixed.

---

## Issues Found and Fixed

### FIXED -- tp1_javascript.md: Truncated story text (Exercice 1)

**File**: `exercises/tp1_javascript.md`
**Severity**: MEDIUM

The `storyText` variable was truncated to `"It was 94 fahrenheit outside, so :insertx: went for a walk..."`. The actual source (`tp1_javascript/First Step/main.js`, line 18) contains the full text including the `:inserty:`, `:insertz:`, and second `:insertx:` placeholders plus the "Bob" reference that the replacement logic depends on.

Also, the `insertZ` array values were shortened (e.g., `"melted into a puddle"` vs actual `"melted into a puddle on the sidewalk"`). Semicolons were added that don't exist in the source.

**Fixed**: Restored the full story text and exact array values from source.

### FIXED -- tp1_javascript.md: Missing UK unit conversion block (Exercice 1)

**File**: `exercises/tp1_javascript.md`
**Severity**: LOW

The source `main.js` (lines 44-49) contains an `if(document.getElementById("uk").checked)` block that converts Fahrenheit to Centigrade and pounds to stone. This was entirely omitted from the guide.

**Fixed**: Added the missing UK conversion block.

### FIXED -- tp1_javascript.md: Comparison operator changed (Exercice 2)

**File**: `exercises/tp1_javascript.md`
**Severity**: LOW

The Building Blocks source (`Building Blocks/main.js`, line 24) uses `==` for the class attribute comparison: `btn.getAttribute("class") == "dark"`. The guide changed this to `===`. While `===` is generally better practice, for a source code reproduction exercise this should match the actual TP code.

**Fixed**: Restored `==` to match source.

### FIXED -- tp1_javascript.md: Template literal vs string concatenation (Exercice 2)

**File**: `exercises/tp1_javascript.md`
**Severity**: LOW

The guide used template literals for image src (`images/pic${i}.jpg`) but the actual source uses string concatenation (`"images/pic" + i + ".jpg"`).

**Fixed**: Matched source code style.

### FIXED -- tp1_javascript.md: Bounce logic restructured (Exercice 3)

**File**: `exercises/tp1_javascript.md`
**Severity**: LOW

The `Ball.prototype.update` method was refactored to use combined `||` conditions and simplified negation (`-this.velX` vs `-(this.velX)`). The source (`Intro Objects/main-finished.js`, lines 43-62) uses four separate `if` statements.

**Fixed**: Restored the four separate if-statements matching source structure.

### FIXED -- tp1_javascript.md: Animation loop changed from for to forEach (Exercice 3)

**File**: `exercises/tp1_javascript.md`
**Severity**: LOW

The guide replaced the source's `for` loop in the animation function with `.forEach()` and arrow functions. The source (lines 102-113) uses a standard `for` loop.

**Fixed**: Restored `for` loop matching source.

### FIXED -- tp1_javascript.md: Color string template literal (Exercice 3)

**File**: `exercises/tp1_javascript.md`
**Severity**: LOW

Collision detection color assignment used template literals but source uses string concatenation.

**Fixed**: Matched source code.

### FIXED -- tp2_rest_api.md: CalendarElement.equals() incomplete (TP2)

**File**: `exercises/tp2_rest_api.md`
**Severity**: MEDIUM

The `equals()` method was missing the `this == o` identity check and the `hashCode()` override that exist in the source (`CalendarElement.java`, lines 29-42).

**Fixed**: Added the `this == o` check and `hashCode()` method.

### FIXED -- tp2_rest_api.md: Misleading addMatiere comment (TP2)

**File**: `exercises/tp2_rest_api.md`
**Severity**: MEDIUM

The comment said "unicite par nom ET annee" but the actual validation (`Agenda.java`, line 59) uses `||` (OR), meaning it rejects if EITHER the name matches OR the year matches any existing subject. The comment implied both conditions must be true simultaneously.

**Fixed**: Changed comment to "rejet si meme nom OU meme annee".

### FIXED -- tp4_orm_jpa.md: ModelElement id type incorrect (TP4)

**File**: `exercises/tp4_orm_jpa.md`
**Severity**: MEDIUM

The guide declared `private long id` with `public long getId()` but the source (`ModelElement.java`, lines 9-10) uses `protected int id` with `public int getId()`.

**Fixed**: Changed to `protected int id` and `public int getId()`.

### FIXED -- guide/04_java_spring_boot.md: DataService missing "bar" and Lombok (Ch4)

**File**: `guide/04_java_spring_boot.md`
**Severity**: LOW

The source `DataService.java` adds both `"foo"` and `"bar"` to the set, uses Lombok `@Getter @Setter`, and does not have explicit getter/setter methods. The guide only showed `"foo"` and had hand-written getters.

**Fixed**: Added `"bar"`, added Lombok annotations, removed manual getters.

### FIXED -- guide/04_java_spring_boot.md: HelloControllerV3 wrong path (Ch4)

**File**: `guide/04_java_spring_boot.md`
**Severity**: LOW

The guide used `@RequestMapping("api/public/v1/hello")` but the actual `HelloControllerV3.java` (line 21) uses `@RequestMapping("api/public/v3/hello")`.

**Fixed**: Changed to `v3`.

### FIXED -- guide/07_web_security.md: Admin route not in actual source (Ch7)

**File**: `guide/07_web_security.md`
**Severity**: LOW

The SecurityConfig showed `.antMatchers("/api/admin/**").hasRole("ADMIN")` as active configuration, but in the source (`SecurityConfig.java`, line 61) this line is commented out. The guide now shows it as a commented-out option.

**Fixed**: Marked as commented-out optional line.

---

## Verified Correct (No Issues)

### guide/01_http_web_fundamentals.md
- HTTP methods (GET, POST, PUT, PATCH, DELETE) and CRUD mapping: CORRECT per RFC 7231/RFC 5789
- Status codes (200, 201, 204, 400, 401, 403, 404, 405, 500): CORRECT per RFC 7231
- REST principles (stateless, client-server, cacheable, uniform interface): CORRECT per Fielding's dissertation
- URL structure diagram: CORRECT
- Spring Boot annotations (@GetMapping, @PostMapping, @RequestBody, @PathVariable, @RequestParam): CORRECT
- PUT vs PATCH distinction: CORRECT

### guide/02_html_css.md
- HTML5 document structure: CORRECT
- Semantic elements (header, nav, main, section, article, aside, footer): CORRECT per HTML5 spec
- CSS specificity values (0,0,1 / 0,1,0 / 1,0,0): CORRECT per CSS Selectors Level 3
- Box Model diagram: CORRECT
- `border-box` calculation (200px + 10px padding + 2px border = 224px without, 200px with): CORRECT
- Flexbox properties: CORRECT
- CSS Grid syntax: CORRECT
- CSS custom properties syntax: CORRECT

### guide/03_javascript.md
- `typeof null === "object"` historical bug: CORRECT
- `const` behavior with objects/arrays: CORRECT
- Arrow function `this` binding: CORRECT
- `==` vs `===` comparison behavior: CORRECT
- Array methods (map, filter, find, reduce, some, every, includes): CORRECT per ECMAScript spec
- Event propagation phases (capture, target, bubbling): CORRECT per DOM Events spec
- Fetch API usage: CORRECT
- ES6 module syntax: CORRECT
- ES6 class syntax matches source model.js: CORRECT

### guide/04_java_spring_boot.md
- Spring Boot annotations (@RestController, @RequestMapping, etc.): CORRECT
- ResponseEntity usage patterns: CORRECT per Spring Framework docs
- ResponseStatusException usage: CORRECT
- Jackson annotations (@JsonIgnore, @JsonSubTypes, @JsonTypeInfo): CORRECT
- MockMvc testing patterns: CORRECT per Spring Testing docs
- Injection by constructor (implicit @Autowired): CORRECT per Spring 4.3+

### guide/05_orm_jpa.md
- JPA annotations (@Entity, @Id, @GeneratedValue): CORRECT per JPA spec
- @OneToMany/@ManyToOne with mappedBy: CORRECT -- matches source Album.java/PlayerCard.java
- @ManyToMany with mappedBy: CORRECT
- CascadeType.PERSIST and FetchType.LAZY: CORRECT -- matches source Album.java
- InheritanceType strategies (SINGLE_TABLE, TABLE_PER_CLASS, JOINED): CORRECT -- matches source Player.java
- CrudRepository methods (save, delete, findById, findAll): CORRECT per Spring Data JPA
- orphanRemoval explanation: CORRECT

### guide/06_xml_json.md
- XML rules (single root, case-sensitive, proper nesting): CORRECT per XML 1.0 spec
- DTD syntax (ELEMENT, ATTLIST, PCDATA, cardinalities): CORRECT
- XSD syntax (complexType, sequence, attribute, minOccurs/maxOccurs): CORRECT
- JSON types and rules: CORRECT per RFC 8259
- Well-formed vs valid distinction: CORRECT
- DS examples (Q.8-Q.12) well-formedness analysis: CORRECT

### guide/07_web_security.md
- XSS description and mitigation (textContent vs innerHTML): CORRECT
- CSRF description: CORRECT
- SQL injection and parameterized queries: CORRECT
- CORS description: CORRECT
- Session/cookie mechanism (JSESSIONID): CORRECT
- Principal usage for user identification: CORRECT per Spring Security

### guide/08_angular_typescript.md
- TypeScript types and interfaces: CORRECT
- Angular component structure (@Component decorator): CORRECT
- Data binding types (interpolation, property, event, two-way): CORRECT per Angular docs
- Lifecycle hooks order (constructor -> ngOnInit -> ngAfterViewInit -> ngOnDestroy): CORRECT
- @Injectable({ providedIn: 'root' }): CORRECT
- HttpClient usage (subscribe required): CORRECT
- *ngIf, *ngFor, ng-container: CORRECT
- @ViewChildren with QueryList<ElementRef>: CORRECT
- RouterModule configuration: CORRECT
- toPromise() for async/await pattern: CORRECT (though deprecated in newer RxJS)

### exercises/tp2_rest_api.md
- JAX-RS annotations (@Path, @GET, @POST, @PathParam, @Singleton): matches CalendarResource.java
- Response building patterns: matches source exactly
- @XmlSeeAlso and JAXB marshalling: matches Cours.java
- JAX-RS vs Spring Boot comparison table: CORRECT

### exercises/tp3_data_formats.md
- XML/JSON well-formedness examples: CORRECT
- DTD writing exercise: CORRECT syntax
- XSD writing exercise: CORRECT syntax including simpleContent/extension for mixed content
- JSON rules: CORRECT per RFC 8259
- Java-to-JSON conversion rules: CORRECT

### exercises/tp4_orm_jpa.md
- Player.java annotations match source: CORRECT (after id type fix)
- Album.java @OneToMany configuration matches source: CORRECT
- PlayerCard.java @Embedded/@AttributeOverrides matches source: CORRECT
- Inheritance strategies explanation: CORRECT

### exercises/tp5_spring_boot.md
- HelloControllerV1 code matches source: CORRECT
- TodoService and injection patterns: Consistent with tp-spring source
- Jackson @JsonSubTypes/@JsonTypeInfo polymorphism: CORRECT
- SecurityConfig matches source (after admin line fix)
- AnimalService/AnimalController matches springboot2 source

### exam-prep/README.md
- DS structure analysis (4 exercises): Consistent with available exam PDFs
- Route verb/status code grid: CORRECT
- JPA methodology: CORRECT
- Security checklist: CORRECT

---

## Notes (Not Bugs, But Worth Mentioning)

1. **Angular toPromise()**: The guide mentions `.toPromise()` in `08_angular_typescript.md`. This method was deprecated in RxJS 7+ (Angular 12+). Modern Angular uses `firstValueFrom()` or `lastValueFrom()` instead. Since the TP source likely targets an older Angular version, this is acceptable but could confuse students using current Angular.

2. **WebSecurityConfigurerAdapter deprecation**: Both the guide and source use `WebSecurityConfigurerAdapter`, which was deprecated in Spring Security 5.7+. The modern approach uses `SecurityFilterChain` beans. This matches the course source material but is outdated for current Spring Boot 3.x projects.

3. **Prototype chain oddity in source**: The `Intro Objects/main-finished.js` source (line 79) contains `Shape.prototype = Object.create(Ball.prototype)` which sets the parent's prototype to the child's -- an unusual and arguably incorrect inheritance setup. The guide correctly describes the intended inheritance direction (Ball inherits from Shape) without reproducing this line.

4. **Source model.js is a stub**: The `es6_babel/src/main/model.js` only contains `Shape` class with `// TODO Rectangle and Line` comments. The guide provides the expected Rectangle and Line implementations inferred from the test files, which is pedagogically appropriate.

5. **POST returning 200 vs 201**: Several source examples (CalendarResource, HelloControllerV1) return `200 OK` for POST operations rather than the HTTP-standard `201 Created`. The guide correctly teaches `201 Created` as the proper response code while faithfully reproducing the source code behavior in TP exercises.
