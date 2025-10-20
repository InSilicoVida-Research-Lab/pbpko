# How to contribute to PBPKO

We welcome contributions to the PBPK Ontology (PBPKO)! This guide will help you get started with contributing to the ontology development.

## Getting Started

### Prerequisites

Before contributing to PBPKO, you should have:

- Basic understanding of ontologies and OWL
- Familiarity with PBPK modeling concepts
- Git and GitHub knowledge
- ROBOT tool experience (recommended)

### Repository Setup

1. **Fork the repository**
   ```bash
   # Fork https://github.com/InSilicoVida-Research-Lab/pbpko on GitHub
   ```

2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/pbpko.git
   cd pbpko
   ```

3. **Add upstream remote**
   ```bash
   git remote add upstream https://github.com/InSilicoVida-Research-Lab/pbpko.git
   ```

## Types of Contributions

### 1. Adding New Terms

To add new terms to PBPKO:

1. **Identify the need** - Check if the term already exists
2. **Use ROBOT templates** - Add terms using the TSV templates in `Robot/templates/`
3. **Follow naming conventions** - Use consistent naming patterns
4. **Provide definitions** - Include clear, concise definitions
5. **Add references** - Cite relevant literature

### 2. Improving Existing Terms

You can improve existing terms by:

- Adding better definitions
- Including synonyms
- Adding references
- Improving relationships
- Adding examples

### 3. Documentation Improvements

Help improve the documentation by:

- Fixing typos and errors
- Adding examples
- Improving clarity
- Adding missing information

### 4. Bug Reports

Report issues by:

- Creating GitHub issues
- Providing detailed descriptions
- Including examples when possible
- Suggesting solutions if you have them

## Contribution Workflow

### 1. Create a Branch

```bash
git checkout -b feature/your-feature-name
```

### 2. Make Changes

- Edit the appropriate files
- Follow the coding standards
- Test your changes

### 3. Commit Changes

```bash
git add .
git commit -m "Add: brief description of changes"
```

### 4. Push and Create Pull Request

```bash
git push origin feature/your-feature-name
```

Then create a pull request on GitHub.

## ROBOT Templates

PBPKO uses ROBOT templates for term management. See [ROBOT Templates](robot_templates.md) for detailed information.

### Template Files

- `vocab.tsv` - Main vocabulary terms
- `properties.tsv` - Object and data properties
- `input.tsv` - Additional input data

## Coding Standards

### Term IDs

- Use format: `PBPKO:XXXXX`
- Sequential numbering
- No gaps in numbering

### Labels

- Use title case
- Be descriptive and concise
- Avoid abbreviations when possible

### Definitions

- Start with capital letter
- End with period
- Be clear and unambiguous
- Include context when helpful

### Synonyms

- Include common abbreviations
- Include alternative spellings
- Use pipe (|) to separate multiple synonyms

## Review Process

All contributions go through a review process:

1. **Automated checks** - ROBOT validation
2. **Peer review** - Team members review changes
3. **Testing** - Verify changes work correctly
4. **Approval** - Maintainer approval required

## Getting Help

If you need help:

- Check existing documentation
- Open a GitHub issue
- Contact the maintainers
- Join our discussions

## Recognition

Contributors are recognized in:

- GitHub contributors list
- Ontology acknowledgements
- Publication acknowledgements (when appropriate)

## Code of Conduct

We follow a code of conduct that promotes:

- Respectful communication
- Inclusive environment
- Constructive feedback
- Professional behavior

## Next Steps

After reading this guide:

1. Check out [ROBOT Templates](robot_templates.md)
2. Look at [Build Process](build_process.md)
3. Review [Managing Documentation](manage_documentation.md)
4. Start contributing!

Thank you for your interest in contributing to PBPKO!
