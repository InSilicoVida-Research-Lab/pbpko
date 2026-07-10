## Customize Makefile settings for pbpko
##
## Native PBPKO terms are authored in src/templates/*.tsv and built into
## components/pbpko-vocab.owl via ROBOT template. To rebuild after editing:
##   sh run.sh make recreate-vocab-from-template
##
## To regenerate templates from the legacy Protege monolith (one-time / audit):
##   python3 src/scripts/extract_pbpko_from_original.py

.PHONY: recreate-vocab-from-template

TEMPLATE_SEED = template-seed.owl
VOCAB_TEMPLATES = $(TEMPLATEDIR)/pbpko-properties.tsv \
	$(TEMPLATEDIR)/pbpko-vocab.tsv \
	$(TEMPLATEDIR)/pbpko-axioms.tsv

recreate-vocab-from-template: $(TEMPLATE_SEED) $(VOCAB_TEMPLATES)
	$(ROBOT) template --input $(TEMPLATE_SEED) --add-prefixes config/context.json \
	 --template $(TEMPLATEDIR)/pbpko-properties.tsv \
	 --template $(TEMPLATEDIR)/pbpko-vocab.tsv \
	 --template $(TEMPLATEDIR)/pbpko-axioms.tsv \
	 annotate --ontology-iri http://purl.obolibrary.org/obo/pbpko/components/pbpko-vocab.owl \
	 --output $(COMPONENTSDIR)/pbpko-vocab.owl.tmp.owl && \
	 mv $(COMPONENTSDIR)/pbpko-vocab.owl.tmp.owl $(COMPONENTSDIR)/pbpko-vocab.owl
