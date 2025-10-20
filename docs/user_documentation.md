# User Documentation

This section provides user-focused documentation for PBPKO, including how to use the ontology, browse terms, and integrate with PBPK modeling tools.

## Getting Started

### What is PBPKO?

The PBPK Ontology (PBPKO) is a standardized vocabulary for physiologically-based pharmacokinetic modeling. It provides:

- **Consistent terminology** across PBPK modeling tools
- **Semantic annotation** capabilities for models
- **Interoperability** between different platforms
- **Reproducible research** through standardized concepts

### Quick Start

1. **Browse the ontology** using online tools
2. **Download** the ontology files
3. **Integrate** with your modeling tools
4. **Annotate** your models using PBPKO terms

## Browsing PBPKO

### Online Browsers

**OLS (Ontology Lookup Service):**
- [PBPKO on OLS](https://www.ebi.ac.uk/ols4/ontologies/pbpko)
- Search and browse terms
- View relationships and definitions
- Export term information

**Ontobee:**
- [PBPKO on Ontobee](http://www.ontobee.org/ontology/PBPKO)
- Alternative browsing interface
- Additional visualization options
- Community annotations

**BioPortal:**
- [PBPKO on BioPortal](https://bioportal.bioontology.org/ontologies/PBPKO)
- Comprehensive ontology browser
- Additional metadata and annotations
- Integration with other ontologies

### Key Terms to Explore

**Core Model Classes:**
- `PBPKO:00003` - Physiologically Based Pharmacokinetic Modeling
- `PBPKO:00004` - Whole Body PBPK Model
- `PBPKO:00005` - Perfusion Limited Model

**Parameter Types:**
- `PBPKO:00006` - Physiological Parameters
- `PBPKO:00126` - Physicochemical Parameters
- `PBPKO:00139` - Biochemical Parameters

**Biological Processes:**
- `PBPKO:00140` - Absorption
- `PBPKO:00146` - Distribution
- `PBPKO:00188` - Metabolism
- `PBPKO:00322` - Elimination

## Using PBPKO

### Model Annotation

**Basic Annotation:**
```turtle
# Example: Annotating a PBPK model
:my_pbpk_model a pbpko:PBPKO_00003 ;
    rdfs:label "My PBPK Model" ;
    pbpko:PBPKO_10001 :absorption_process ;
    pbpko:PBPKO_10001 :distribution_process ;
    pbpko:PBPKO_10001 :metabolism_process ;
    pbpko:PBPKO_10001 :elimination_process .
```

**Parameter Annotation:**
```turtle
# Example: Annotating parameters
:liver_volume a pbpko:PBPKO_00066 ;
    rdfs:label "Liver Volume" ;
    rdfs:comment "Volume of liver compartment" ;
    pbpko:PBPKO_10005 :my_pbpk_model .
```

### Tool Integration

**ROBOT Integration:**
```bash
# Extract specific terms
robot extract --input pbpko.owl \
              --term-file terms.txt \
              --output extracted.owl
```

**SPARQL Queries:**
```sparql
# Find all parameter classes
PREFIX pbpko: <http://purl.obolibrary.org/obo/pbpko#>
SELECT ?term ?label WHERE {
    ?term rdfs:subClassOf pbpko:PBPKO_00002 .
    ?term rdfs:label ?label .
}
```

## Common Use Cases

### 1. Model Documentation

**Use PBPKO to:**
- Document model components
- Standardize terminology
- Enable model comparison
- Support reproducibility

**Example:**
```turtle
:my_model a pbpko:PBPKO_00003 ;
    pbpko:PBPKO_10002 :central_compartment ;
    pbpko:PBPKO_10002 :liver_compartment ;
    pbpko:PBPKO_10002 :kidney_compartment ;
    pbpko:PBPKO_10005 :cardiac_output ;
    pbpko:PBPKO_10005 :liver_volume .
```

### 2. Parameter Standardization

**Use PBPKO to:**
- Standardize parameter names
- Define parameter relationships
- Enable parameter sharing
- Support validation

**Example:**
```turtle
:cardiac_output a pbpko:PBPKO_00013 ;
    rdfs:label "Cardiac Output" ;
    rdfs:comment "Volume of blood pumped by heart per unit time" ;
    pbpko:PBPKO_10005 :my_model .
```

### 3. Process Annotation

**Use PBPKO to:**
- Annotate biological processes
- Define process relationships
- Enable process comparison
- Support mechanistic modeling

**Example:**
```turtle
:hepatic_metabolism a pbpko:PBPKO_00188 ;
    rdfs:label "Hepatic Metabolism" ;
    rdfs:comment "Drug metabolism in liver" ;
    pbpko:PBPKO_10001 :my_model .
```

## Best Practices

### Annotation Guidelines

**Consistent Labeling:**
- Use descriptive labels
- Follow naming conventions
- Include units when appropriate
- Provide clear definitions

**Relationship Usage:**
- Use appropriate property types
- Maintain logical consistency
- Document relationships clearly
- Validate relationships

### Quality Assurance

**Validation Steps:**
- Check term definitions
- Verify relationships
- Validate logical consistency
- Test with reasoners

**Common Issues:**
- Inconsistent naming
- Missing definitions
- Incorrect relationships
- Logical inconsistencies

## Troubleshooting

### Common Questions

**Q: How do I find the right term?**
A: Use the online browsers to search for terms, or browse the hierarchy to find related concepts.

**Q: Can I add new terms?**
A: Yes, see the [Contributing Guide](contributing.md) for information on adding new terms.

**Q: How do I validate my annotations?**
A: Use ROBOT or other OWL tools to validate your annotations for consistency.

### Getting Help

**Resources:**
- [Documentation](index.md) - Comprehensive guides
- [GitHub Issues](https://github.com/InSilicoVida-Research-Lab/pbpko/issues) - Bug reports and questions
- [Community Discussions](https://github.com/InSilicoVida-Research-Lab/pbpko/discussions) - User discussions

**Contact:**
- **Email:** saurav.kumar@iispv.cat
- **GitHub:** Open an issue
- **Community:** Join discussions

## Examples and Tutorials

### Tutorial Series

1. **Introduction to PBPKO** - Basic concepts and usage
2. **Browsing and Searching** - Finding terms and relationships
3. **Model Annotation** - Annotating PBPK models
4. **Tool Integration** - Using PBPKO with modeling tools
5. **Advanced Usage** - Complex annotation scenarios

### Example Models

**Simple Two-Compartment Model:**
- Central compartment
- Peripheral compartment
- Basic parameters
- Simple processes

**Complex Multi-Organ Model:**
- Multiple organ compartments
- Detailed parameters
- Complex processes
- Advanced relationships

## Resources

### Documentation

- [PBPKO Documentation](index.md) - Main documentation
- [Contributing Guide](contributing.md) - How to contribute
- [ROBOT Templates](robot_templates.md) - Template usage
- [Build Process](build_process.md) - Technical details

### Tools

- [ROBOT](http://robot.obolibrary.org/) - Ontology development
- [Protégé](https://protege.stanford.edu/) - Ontology editor
- [OLS](https://www.ebi.ac.uk/ols4/) - Ontology browser
- [Ontobee](http://www.ontobee.org/) - Alternative browser

### Community

- [GitHub Repository](https://github.com/InSilicoVida-Research-Lab/pbpko)
- [Issue Tracker](https://github.com/InSilicoVida-Research-Lab/pbpko/issues)
- [Discussions](https://github.com/InSilicoVida-Research-Lab/pbpko/discussions)
- [Releases](releases.md) - Download latest versions
