# Manage Automated Tests

This page describes the automated testing framework for PBPKO, including test setup, execution, and maintenance.

## Overview

PBPKO uses automated testing to ensure:
- Ontology quality and consistency
- Template validation
- Build process reliability
- Documentation accuracy

## Test Framework

### ROBOT Testing

**ROBOT Test Commands:**
```bash
# Run all tests
robot test --input Robot/ontologies/pbpko.owl --test all

# Run specific test suite
robot test --input Robot/ontologies/pbpko.owl --test Robot/tests/

# Generate test report
robot test --input Robot/ontologies/pbpko.owl --output reports/test-report.html
```

### Test Categories

#### 1. Ontology Validation Tests

**Syntax Validation:**
```bash
robot validate --input Robot/ontologies/pbpko.owl
```

**Logical Consistency:**
```bash
robot reason --input Robot/ontologies/pbpko.owl --reasoner hermit
```

**Property Validation:**
```bash
robot validate --input Robot/ontologies/pbpko.owl --profile profile.txt
```

#### 2. Template Tests

**Template Format Validation:**
```bash
robot template --template Robot/templates/vocab.tsv --check
```

**Template Content Validation:**
```bash
robot template --template Robot/templates/vocab.tsv --validate
```

**Template Processing Tests:**
```bash
robot template --template Robot/templates/vocab.tsv --output test-output.owl
```

#### 3. Build Process Tests

**Complete Build Test:**
```bash
./scripts/test-build.sh
```

**Individual Component Tests:**
```bash
./scripts/test-templates.sh
./scripts/test-merge.sh
./scripts/test-validation.sh
```

## Test Configuration

### Test Profiles

**profile.txt:**
```
# ROBOT validation profile
# Syntax validation
syntax

# Logical consistency
logical

# Property restrictions
property-restrictions

# Class hierarchy
class-hierarchy
```

### Test Data

**Test Templates:**
- `Robot/tests/vocab-test.tsv` - Test vocabulary
- `Robot/tests/properties-test.tsv` - Test properties
- `Robot/tests/input-test.tsv` - Test input data

**Expected Outputs:**
- `Robot/tests/expected-output.owl` - Expected ontology
- `Robot/tests/expected-report.html` - Expected report

## Automated Test Execution

### GitHub Actions Integration

**Test Workflow:**
```yaml
name: Automated Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup Java
        uses: actions/setup-java@v2
        with:
          java-version: '11'
      - name: Download ROBOT
        run: wget https://github.com/ontodev/robot/releases/download/v1.8.1/robot.jar
      - name: Run tests
        run: ./scripts/run-tests.sh
      - name: Upload test results
        uses: actions/upload-artifact@v2
        with:
          name: test-results
          path: reports/
```

### Local Test Execution

**Run Tests Locally:**
```bash
# Run all tests
./scripts/run-tests.sh

# Run specific test suite
./scripts/run-tests.sh --suite ontology

# Run with verbose output
./scripts/run-tests.sh --verbose
```

## Test Types

### Unit Tests

**Individual Component Testing:**
- Template validation
- Individual term testing
- Property testing
- Import testing

**Example Unit Test:**
```bash
# Test individual template
robot template --template Robot/templates/vocab.tsv --check

# Test individual term
robot validate --input Robot/ontologies/edit.owl --term PBPKO:00001
```

### Integration Tests

**Component Integration Testing:**
- Template to ontology conversion
- Import merging
- Complete build process
- Output validation

**Example Integration Test:**
```bash
# Test complete build
./scripts/build.sh
robot validate --input Robot/ontologies/pbpko.owl
```

### Regression Tests

**Regression Testing:**
- Compare with previous versions
- Check for breaking changes
- Validate backward compatibility
- Performance regression testing

**Example Regression Test:**
```bash
# Compare with previous version
robot diff --left Robot/ontologies/pbpko-previous.owl \
           --right Robot/ontologies/pbpko-current.owl
```

## Test Reporting

### Test Reports

**HTML Reports:**
```bash
robot test --input Robot/ontologies/pbpko.owl \
           --output reports/test-report.html
```

**JSON Reports:**
```bash
robot test --input Robot/ontologies/pbpko.owl \
           --output reports/test-report.json
```

**CSV Reports:**
```bash
robot test --input Robot/ontologies/pbpko.owl \
           --output reports/test-report.csv
```

### Test Metrics

**Metrics Tracked:**
- Test execution time
- Success/failure rates
- Coverage metrics
- Performance metrics

**Example Metrics:**
```bash
# Generate metrics report
./scripts/generate-metrics.sh
```

## Quality Assurance

### Test Coverage

**Coverage Areas:**
- All ontology terms
- All properties
- All templates
- All build steps

**Coverage Reporting:**
```bash
# Generate coverage report
./scripts/coverage-report.sh
```

### Test Quality

**Quality Metrics:**
- Test reliability
- Test maintainability
- Test performance
- Test coverage

**Quality Checks:**
```bash
# Run quality checks
./scripts/quality-checks.sh
```

## Continuous Testing

### Automated Execution

**Trigger Events:**
- Code commits
- Pull requests
- Scheduled runs
- Manual triggers

**Execution Schedule:**
- On every commit
- Daily scheduled runs
- Weekly comprehensive tests
- Monthly performance tests

### Test Monitoring

**Monitoring Metrics:**
- Test execution time
- Success rates
- Failure patterns
- Performance trends

**Alerting:**
- Email notifications for failures
- Slack integration for team updates
- GitHub issue creation for errors
- Dashboard updates

## Test Maintenance

### Regular Updates

**Update Schedule:**
- Monthly test review
- Quarterly test updates
- Annual test overhaul
- Continuous improvement

### Test Documentation

**Documentation Requirements:**
- Test descriptions
- Test procedures
- Expected results
- Troubleshooting guides

### Test Versioning

**Version Control:**
- Test script versioning
- Test data versioning
- Test configuration versioning
- Test result archiving

## Troubleshooting

### Common Issues

**Test Failures:**
- Check ROBOT version
- Verify test data
- Validate test configuration
- Review test logs

**Performance Issues:**
- Monitor resource usage
- Optimize test scripts
- Use parallel execution
- Cache test data

### Debug Mode

**Enable Debug Output:**
```bash
# Run tests with debug output
./scripts/run-tests.sh --debug

# Verbose ROBOT output
robot --verbose test --input Robot/ontologies/pbpko.owl
```

## Best Practices

### Test Design

**Design Principles:**
- Keep tests simple and focused
- Use descriptive test names
- Include clear assertions
- Maintain test independence

### Test Data

**Data Management:**
- Use minimal test data
- Keep test data current
- Validate test data
- Document test data

### Test Execution

**Execution Best Practices:**
- Run tests frequently
- Use parallel execution
- Monitor test performance
- Maintain test logs

## Resources

### Documentation

- [ROBOT Test Documentation](http://robot.obolibrary.org/test)
- [GitHub Actions Testing](https://docs.github.com/en/actions/automating-builds-and-tests)
- [Testing Best Practices](https://testing.googleblog.com/)

### Tools

- [ROBOT](https://github.com/ontodev/robot)
- [GitHub Actions](https://github.com/features/actions)
- [TestNG](https://testng.org/)
- [JUnit](https://junit.org/)

### Examples

- [PBPKO Test Scripts](https://github.com/InSilicoVida-Research-Lab/pbpko/tree/main/scripts)
- [Test Configuration](https://github.com/InSilicoVida-Research-Lab/pbpko/tree/main/Robot/tests)
- [Test Reports](https://github.com/InSilicoVida-Research-Lab/pbpko/tree/main/reports)
