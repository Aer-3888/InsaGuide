# JSON Processing

## Objective

Learn JSON syntax and processing in both JavaScript and Java environments.

## Files

### Sample Data

**person.json**
```json
{
    "idcard": "1843739",
    "name": "John Doe",
    "address": ["Adress 1", "Adress 2"],
    "phones": {
        "work": "+339999999",
        "home": "+338888888"
    }
}
```

## JSON vs. XML

| Feature | JSON | XML |
|---------|------|-----|
| **Syntax** | JavaScript-like | Tag-based |
| **Readability** | High | Moderate |
| **Size** | Compact | Verbose |
| **Arrays** | Native `[]` | Repeated elements |
| **Objects** | Native `{}` | Nested elements |
| **Comments** | Not allowed | Allowed |
| **Validation** | JSON Schema | DTD/XSD/Relax NG |

## Processing Methods

### JavaScript (js/)

Native JSON support in all browsers and Node.js:

```javascript
// Parse JSON string to object
const person = JSON.parse(jsonString);

// Access properties
console.log(person.name);           // "John Doe"
console.log(person.address[0]);     // "Adress 1"
console.log(person.phones.work);    // "+339999999"

// Convert object to JSON string
const jsonString = JSON.stringify(person);

// Pretty print with indentation
const prettyJson = JSON.stringify(person, null, 2);
```

**Key Operations**:
- `JSON.parse()` - String to object
- `JSON.stringify()` - Object to string
- Direct property access with dot notation
- Array iteration with `forEach`, `map`, `filter`

### Java (java/)

Using libraries like Jackson or Gson for JSON processing:

```java
// Parse JSON to Java object (Jackson)
ObjectMapper mapper = new ObjectMapper();
Person person = mapper.readValue(jsonString, Person.class);

// Convert Java object to JSON
String json = mapper.writeValueAsString(person);

// Parse to generic JsonNode
JsonNode root = mapper.readTree(jsonString);
String name = root.get("name").asText();
```

**Common Libraries**:
- **Jackson** - Fast, feature-rich, industry standard
- **Gson** - Simple, Google-maintained
- **JSON-P** - Java EE standard (javax.json)
- **JSON-B** - Java EE binding standard

## JSON Schema Validation

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "idcard": { "type": "string", "pattern": "^[0-9]+$" },
    "name": { "type": "string", "minLength": 1 },
    "address": {
      "type": "array",
      "items": { "type": "string" },
      "minItems": 1
    },
    "phones": {
      "type": "object",
      "properties": {
        "work": { "type": "string" },
        "home": { "type": "string" }
      }
    }
  },
  "required": ["idcard", "name"]
}
```

## Common JSON Patterns

### Nested Objects
```json
{
  "user": {
    "profile": {
      "name": "John",
      "age": 30
    }
  }
}
```

### Arrays of Objects
```json
{
  "users": [
    { "id": 1, "name": "Alice" },
    { "id": 2, "name": "Bob" }
  ]
}
```

### Null Values
```json
{
  "optional": null,
  "required": "value"
}
```

## Best Practices

1. **Use meaningful keys** - `user_id` not `uid`
2. **Consistent naming** - camelCase or snake_case
3. **Avoid deep nesting** - Max 3-4 levels
4. **Use arrays for lists** - Not `item1`, `item2`, `item3`
5. **Validate with schemas** - Catch errors early
6. **Escape special characters** - Use `\"` for quotes
7. **UTF-8 encoding** - Default for JSON

## Learning Outcomes

- Parse and serialize JSON in JavaScript and Java
- Choose JSON vs. XML for data interchange
- Design JSON structures for APIs
- Validate JSON with schemas
- Handle nested objects and arrays
- Work with JSON in RESTful APIs
