# XML Processing

## Objective

Learn XML syntax, validation, and schema definitions using DTD, XSD, and Relax NG.

## Files

### Sample Data

**person.xml**
```xml
<?xml version="1.0"?>
<person idcard="1843739">
    <name>John Doe</name>
    <address>Adress 1</address>
    <address>Adress 2</address>
</person>
```

**validdoc.xml** - Well-formed and valid XML document
**illformedDoc.xml** - Malformed XML for error testing

### Schema Definitions

**person.dtd** - Document Type Definition
- Defines structure for person elements
- Attribute declarations
- Element content models

**person.xsd** - XML Schema Definition
- Type-safe validation
- Data type constraints
- Namespace support

**person.rnc** - Relax NG Compact Syntax
- Modern schema language
- More readable than XSD
- Pattern-based validation

## Key Concepts

### XML Fundamentals
- Well-formedness rules
- Element nesting and hierarchy
- Attributes vs. elements
- Character encoding (UTF-8)

### Validation Methods
1. **DTD** - Legacy, simple, limited types
2. **XSD** - W3C standard, strong typing, verbose
3. **Relax NG** - Modern, concise, flexible

### Validation Tools

```bash
# Validate with xmllint (libxml2)
xmllint --noout --valid validdoc.xml

# Validate against XSD
xmllint --noout --schema person.xsd person.xml

# Check well-formedness only
xmllint --noout person.xml

# Detect ill-formed XML
xmllint --noout illformedDoc.xml  # Will show errors
```

## Common XML Patterns

### Multiple Occurrences
```xml
<!-- Multiple address elements -->
<person>
    <name>John Doe</name>
    <address>Home</address>
    <address>Work</address>
</person>
```

### Attributes vs. Elements
```xml
<!-- ID as attribute (concise, metadata) -->
<person idcard="1843739">

<!-- ID as element (verbose, can have children) -->
<person>
    <idcard>1843739</idcard>
</person>
```

## Learning Outcomes

- Write well-formed XML documents
- Validate XML against schemas
- Choose appropriate validation method (DTD/XSD/Relax NG)
- Design XML structures for data interchange
- Debug XML syntax errors
