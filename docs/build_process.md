# Build Process

This page describes the build process for PBPKO, including how to generate the ontology from templates and manage releases.

## Overview

The PBPKO build process uses ROBOT to:
1. Generate ontology from TSV templates
2. Merge with imported ontologies
3. Validate the resulting ontology
4. Generate release files

## Build Steps

### 1. Template Processing

**Generate edit.owl from templates:**
```bash
robot template --template Robot/templates/vocab.tsv \
               --template Robot/templates/properties.tsv \
               --output Robot/ontologies/edit.owl
```

### 2. Import Management

**Update imported modules:**
```bash
robot extract --input Robot/ontologies/imported_modules.owl \
              --term-file Robot/extracted_terms/imported_modules/go_terms.txt \
              --output Robot/ontologies/go_module.owl
```

### 3. Ontology Merging

**Merge edit.owl with imports:**
```bash
robot merge --input Robot/ontologies/edit.owl \
           --input Robot/ontologies/imported_modules.owl \
           --output Robot/ontologies/pbpko.owl
```

### 4. Validation

**Validate the ontology:**
```bash
robot validate --input Robot/ontologies/pbpko.owl
```

**Check for errors:**
```bash
robot report --input Robot/ontologies/pbpko.owl \
             --output reports/pbpko-report.html
```

## Build Scripts

### Complete Build

**Run full build process:**
```bash
./scripts/build.sh
```

**Windows:**
```cmd
scripts\build.bat
```

### Individual Steps

**Template only:**
```bash
./scripts/template.sh
```

**Merge only:**
```bash
./scripts/merge.sh
```

**Validate only:**
```bash
./scripts/validate.sh
```

## Build Configuration

### ROBOT Configuration

**robot-config.yaml:**
```yaml
build:
  inputs:
    - edit.owl
    - imported_modules.owl
  outputs:
    - pbpko.owl
  reports:
    - pbpko-report.html
```

### Template Configuration

**Template settings in TSV files:**
- Column headers must match ROBOT expectations
- IDs must follow PBPKO format
- Required columns must be filled

## Release Process

### 1. Pre-release Checks

- [ ] All templates validated
- [ ] Imports updated
- [ ] Tests passing
- [ ] Documentation updated

### 2. Version Management

**Update version in:**
- `Robot/ontologies/catalog-v001.xml`
- Release notes
- Documentation

### 3. Release Generation

**Generate release files:**
```bash
robot convert --input Robot/ontologies/pbpko.owl \
              --format owl \
              --output releases/pbpko.owl
```

**Generate different formats:**
```bash
# OBO format
robot convert --input Robot/ontologies/pbpko.owl \
              --format obo \
              --output releases/pbpko.obo

# JSON-LD format
robot convert --input Robot/ontologies/pbpko.owl \
              --format json \
              --output releases/pbpko.json
```

## Continuous Integration

### GitHub Actions

**Build on every push:**
```yaml
name: Build PBPKO
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup ROBOT
        run: |
          wget https://github.com/ontodev/robot/releases/download/v1.8.1/robot.jar
      - name: Build ontology
        run: ./scripts/build.sh
```

### Automated Testing

**Run tests:**
```bash
robot test --input Robot/ontologies/pbpko.owl \
           --test all
```

## Troubleshooting

### Common Build Errors

**Template errors:**
- Check TSV format
- Verify column headers
- Ensure required fields are filled

**Import errors:**
- Verify import URLs
- Check network connectivity
- Update import versions

**Merge conflicts:**
- Resolve duplicate terms
- Check logical consistency
- Validate relationships

### Debug Mode

**Enable verbose output:**
```bash
robot --verbose template --template Robot/templates/vocab.tsv
```

**Check intermediate files:**
```bash
ls -la Robot/ontologies/
```

## Performance Optimization

### Build Speed

- Use incremental builds when possible
- Cache imported ontologies
- Parallel processing for large templates

### Memory Usage

- Process templates in batches
- Use streaming for large files
- Monitor memory usage

## Best Practices

### Version Control

- Commit templates separately from generated files
- Use meaningful commit messages
- Tag releases appropriately

### Documentation

- Document build process changes
- Update scripts when needed
- Maintain build logs

### Testing

- Test builds on different systems
- Validate outputs thoroughly
- Check for regressions

## Resources

- [ROBOT Documentation](http://robot.obolibrary.org/)
- [OBO Build Tools](https://oboacademy.github.io/obook/)
- [PBPKO Build Scripts](https://github.com/InSilicoVida-Research-Lab/pbpko/tree/main/scripts)
