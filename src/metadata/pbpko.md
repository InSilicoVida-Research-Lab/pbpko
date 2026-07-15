---
layout: ontology_detail
id: pbpko
title: Physiologically-Based Pharmacokinetic Ontology
preferredPrefix: PBPKO
description: An ontology for describing PBPK models, parameters, compartments, and pharmacokinetic processes in biological systems.
domain: chemistry and biochemistry
homepage: https://insilicovida-research-lab.github.io/pbpko/
repository: https://github.com/InSilicoVida-Research-Lab/pbpko
tracker: https://github.com/InSilicoVida-Research-Lab/pbpko/issues
contact:
  email: saurav.kumar@iispv.cat
  label: Saurav Kumar
  github: InSilicoVida-Research-Lab
  orcid: 0000-0003-0593-2598
license:
  label: CC BY 4.0
  url: https://creativecommons.org/licenses/by/4.0/
dependencies:
  - id: bfo
  - id: ro
  - id: go
  - id: obi
  - id: iao
products:
  - id: pbpko.owl
    name: PBPK Ontology main release in OWL format
  - id: pbpko.obo
    name: PBPK Ontology main release in OBO format
  - id: pbpko-base.owl
    name: PBPK Ontology base release in OWL format
  - id: pbpko-base.obo
    name: PBPK Ontology base release in OBO format
  - id: pbpko-full.owl
    name: PBPK Ontology full release in OWL format
  - id: pbpko-full.obo
    name: PBPK Ontology full release in OBO format
browsers:
  - title: OLS
    label: OLS
    url: https://www.ebi.ac.uk/ols4/ontologies/pbpko
  - title: BioPortal Ontology Browser
    label: BioPortal
    url: https://bioportal.bioontology.org/ontologies/pbpko
jobs:
  - id: https://github.com/InSilicoVida-Research-Lab/pbpko/actions/workflows/qc.yml
    type: github-actions
usages:
  - description: PBPKO supports consistent vocabulary for PBPK modelling and annotation of kinetic models.
    user: https://github.com/InSilicoVida-Research-Lab
activity_status: active
---

The **Physiologically Based Pharmacokinetic Ontology (PBPKO)** provides a dedicated controlled vocabulary
for PBPK models, physiological and biochemical parameters, compartments, and related pharmacokinetic
processes. PBPKO is developed with the [Ontology Development Kit (ODK)](https://github.com/INCATools/ontology-development-kit)
and released under OBO Foundry dated versioning (`vYYYY-MM-DD`).

Documentation: [https://insilicovida-research-lab.github.io/pbpko/](https://insilicovida-research-lab.github.io/pbpko/)
