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
