## Customize Makefile settings for pbpko
##
## PBPKO uses edit-file-only authoring: all native classes, properties, labels,
## definitions, parents, and logical axioms live in pbpko-edit.owl (Protégé).
##
## TSV files under src/templates/ are view-only exports (make export-vocab-view).
## Do not edit TSV to change the ontology.
##
## Legacy template seed files are archived under src/templates/archive/.

# Disable ROBOT template component merge — edit file is the sole native source.
OTHER_SRC =

VOCAB_VIEW = $(TEMPLATEDIR)/pbpko-vocab-view.tsv
PROPERTIES_VIEW = $(TEMPLATEDIR)/pbpko-properties-view.tsv

.PHONY: export-vocab-view export-properties-view export-term-views

export-vocab-view: $(SRC)
	$(ROBOT) export -i $< -n classes \
	 -c "ID|LABEL|IAO:0000115|SubClassOf" -f tsv -e $(VOCAB_VIEW).tmp
	@{ head -1 $(VOCAB_VIEW).tmp; grep '^pbpko:PBPKO_' $(VOCAB_VIEW).tmp; } > $(VOCAB_VIEW)
	@rm -f $(VOCAB_VIEW).tmp

export-properties-view: $(SRC)
	$(ROBOT) export -i $< -n properties \
	 -c "ID|LABEL|IAO:0000115" -f tsv -e $(PROPERTIES_VIEW).tmp
	@{ head -1 $(PROPERTIES_VIEW).tmp; grep '^pbpko:PBPKO_' $(PROPERTIES_VIEW).tmp; } > $(PROPERTIES_VIEW)
	@rm -f $(PROPERTIES_VIEW).tmp

export-term-views: export-vocab-view export-properties-view

# ODK default downloads the live PURL for release-diff; PBPKO PURL may still
# point at the deleted legacy Robot/ path until OBO Foundry config is updated.
# CI pre-seeds tmp/current-release.owl; otherwise wget with empty fallback.
$(TMPDIR)/current-release.owl:
	@if [ -s $@ ]; then \
	  echo "Using existing $@ for release diff baseline"; \
	else \
	  wget -q $(CURRENT_RELEASE) -O $@ || \
	  echo '<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"/>' > $@; \
	fi

# Keep ontology metadata aligned with OBO dated releases.
update_edit_modified:
	sed -i 's/Annotation(dcterms:modified "[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]"^^xsd:date)/Annotation(dcterms:modified "$(VERSION)"^^xsd:date)/' $(SRC)

prepare_release_fast: update_edit_modified
	$(MAKE) prepare_release IMP=false PAT=false MIR=false COMP=false

TERM_SPARQL_VALIDATION_CHECKS = owldef-self-reference iri-range label-with-iri multiple-replaced_by pbpko-id-format
ONTOLOGY_METADATA_CHECKS = ontology-duplicate-title ontology-license ontology-missing-homepage
SPARQL_VALIDATION_CHECKS = $(TERM_SPARQL_VALIDATION_CHECKS) $(ONTOLOGY_METADATA_CHECKS)

.PHONY: sparql_test
sparql_test: $(SRCMERGED) pbpko-base.owl | $(REPORTDIR)
	$(ROBOT) verify -i $(SRCMERGED) --queries $(foreach V,$(SPARQL_VALIDATION_CHECKS),$(SPARQLDIR)/$(V)-violation.sparql) -O $(REPORTDIR)
	$(ROBOT) verify -i pbpko-base.owl --queries $(foreach V,$(TERM_SPARQL_VALIDATION_CHECKS),$(SPARQLDIR)/$(V)-violation.sparql) -O $(REPORTDIR)

.PHONY: metadata_release_test
metadata_release_test: $(RELEASEDIR)/pbpko.owl | $(REPORTDIR)
	$(ROBOT) verify -i $(RELEASEDIR)/pbpko.owl --queries $(SPARQLDIR)/release-metadata-violation.sparql -O $(REPORTDIR)
