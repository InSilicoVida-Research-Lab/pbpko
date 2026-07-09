# PBPKO ontology build and QC
# Run from Robot/: make test

ONTOLOGY := ontologies/pbpko.owl
REPORTS_DIR := reports
BASE_IRI := http://purl.obolibrary.org/obo/PBPKO_
ROBOT_IMAGE ?= obolibrary/odkfull:v1.6
ROBOT_JAVA_ARGS ?= -Xmx6G
SKIP_FULL_REASON ?= false

ROBOT = docker run -v $(CURDIR):/work -w /work \
	-e ROBOT_JAVA_ARGS=$(ROBOT_JAVA_ARGS) -e JAVA_OPTS= --rm $(ROBOT_IMAGE) robot

SPARQL_QUERIES := sparql/owldef-self-reference-violation.sparql \
	sparql/iri-range-violation.sparql \
	sparql/label-with-iri-violation.sparql \
	sparql/multiple-replaced_by-violation.sparql \
	sparql/pbpko-id-format-violation.sparql

.PHONY: test qc validate-profile report verify reason clean-reports

test: validate-profile report verify reason

qc: test

validate-profile:
	mkdir -p $(REPORTS_DIR)
	$(ROBOT) validate-profile --profile DL -i $(ONTOLOGY)

report:
	mkdir -p $(REPORTS_DIR)
	$(ROBOT) report -i $(ONTOLOGY) --base-iri $(BASE_IRI) \
		--profile qc/profile.txt --fail-on ERROR \
		-o $(REPORTS_DIR)/robot_report.tsv

verify:
	mkdir -p $(REPORTS_DIR)/verify
	$(ROBOT) verify -i $(ONTOLOGY) -q $(SPARQL_QUERIES) \
		-O $(REPORTS_DIR)/verify

reason:
	mkdir -p $(REPORTS_DIR)
	$(ROBOT) reason -i $(ONTOLOGY) -r ELK -e none \
		-o $(REPORTS_DIR)/reasoned.owl

clean-reports:
	rm -rf $(REPORTS_DIR)
