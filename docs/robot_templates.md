# ROBOT Templates

PBPKO uses ROBOT templates for systematic ontology development and maintenance. This page explains how to use the template system effectively.

## Overview

ROBOT templates provide a structured way to manage ontology terms using TSV (Tab-Separated Values) files. This approach ensures consistency and enables automated processing.

## Template Files

### 1. vocab.tsv

**Purpose:** Main vocabulary terms and classes

**Location:** `Robot/templates/vocab.tsv`

**Key Columns:**
- `ID` - Term identifier (e.g., `pbpko:PBPKO_00001`)
- `Label` - Human-readable label
- `Definition` - Textual definition
- `Parent` - Parent class
- `Type` - OWL class type
- `Editor` - Contributor ORCID
- `Reviewer1` - First reviewer ORCID
- `Reviewer2` - Second reviewer ORCID

### 2. properties.tsv

**Purpose:** Object and data properties

**Location:** `Robot/templates/properties.tsv`

**Key Columns:**
- `ID` - Property identifier
- `Label` - Property label
- `Type` - Property type (owl:ObjectProperty, owl:DataProperty)
- `Super Property` - Parent property
- `Domain` - Property domain
- `Range` - Property range

### 3. input.tsv

**Purpose:** Additional input data and configurations

**Location:** `Robot/templates/input.tsv`

## Template Usage

### Adding New Terms

1. **Open vocab.tsv**
2. **Add new row with:**
   - Unique ID (next sequential number)
   - Descriptive label
   - Clear definition
   - Appropriate parent class
   - Editor information

**Example:**
```tsv
pbpko:PBPKO_00099	New Parameter	Definition of new parameter	Parameters	Class	0000-0001-8345-1349	0000-0002-9795-5967
```

### Adding Properties

1. **Open properties.tsv**
2. **Add new row with:**
   - Unique property ID
   - Property label
   - Property type
   - Domain and range if applicable

**Example:**
```tsv
pbpko:PBPKO_10099	has_new_property	owl:ObjectProperty	pbpko:has_parameter	PBPK Model	Parameter
```

## Template Processing

### ROBOT Commands

**Generate ontology from templates:**
```bash
robot template --template Robot/templates/vocab.tsv \
               --template Robot/templates/properties.tsv \
               --output Robot/ontologies/edit.owl
```

**Validate templates:**
```bash
robot template --template Robot/templates/vocab.tsv --check
```

**Merge with imports:**
```bash
robot merge --input Robot/ontologies/edit.owl \
           --input Robot/ontologies/imported_modules.owl \
           --output Robot/ontologies/pbpko.owl
```

## Best Practices

### Term Creation

1. **Consistent Naming**
   - Use title case for labels
   - Avoid abbreviations in labels
   - Use consistent terminology

2. **Clear Definitions**
   - Start with capital letter
   - End with period
   - Be specific and unambiguous
   - Include context when helpful

3. **Proper Classification**
   - Choose appropriate parent classes
   - Follow ontological principles
   - Maintain logical hierarchy

### Property Creation

1. **Meaningful Names**
   - Use descriptive property names
   - Follow naming conventions
   - Avoid generic terms

2. **Proper Domains and Ranges**
   - Specify appropriate domains
   - Define clear ranges
   - Ensure logical consistency

### Documentation

1. **Complete Information**
   - Fill all required columns
   - Provide editor information
   - Include reviewer assignments

2. **References**
   - Cite relevant literature
   - Provide source URLs
   - Include DOI when available

## Template Validation

### Automated Checks

ROBOT performs several validation checks:

- **Syntax validation** - TSV format correctness
- **ID uniqueness** - No duplicate IDs
- **Reference validation** - Valid parent classes
- **Logical consistency** - Ontological soundness

### Manual Review

Before submitting:

1. **Check definitions** - Ensure clarity and accuracy
2. **Verify relationships** - Confirm logical connections
3. **Review naming** - Check consistency
4. **Validate references** - Ensure citations are correct

## Common Issues

### Template Errors

**Missing required columns:**
- Ensure all mandatory columns are filled
- Use empty cells for optional information

**Invalid IDs:**
- Follow ID format: `pbpko:PBPKO_XXXXX`
- Use sequential numbering
- Avoid gaps in numbering

**Circular references:**
- Check parent-child relationships
- Ensure no circular dependencies

### Processing Errors

**ROBOT template errors:**
- Check TSV format
- Verify column headers
- Ensure proper escaping

**Merge conflicts:**
- Resolve import conflicts
- Check for duplicate terms
- Validate logical consistency

## Advanced Usage

### Custom Templates

You can create custom templates for specific purposes:

1. **Specialized vocabularies**
2. **Domain-specific terms**
3. **Temporary term collections**

### Template Automation

Consider automating template processing:

1. **CI/CD integration**
2. **Automated validation**
3. **Scheduled processing**

## Getting Help

For template-related issues:

1. Check ROBOT documentation
2. Review existing templates
3. Contact maintainers
4. Open GitHub issues

## Resources

- [ROBOT Documentation](http://robot.obolibrary.org/)
- [Template Tutorial](http://robot.obolibrary.org/template)
- [OBO Tutorial](https://oboacademy.github.io/obook/)
- [PBPKO Templates](https://github.com/InSilicoVida-Research-Lab/pbpko/tree/main/Robot/templates)
