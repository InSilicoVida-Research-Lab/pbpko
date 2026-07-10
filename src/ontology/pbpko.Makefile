## Customize Makefile settings for pbpko
##
## Native PBPKO classes and object properties are seeded from src/templates/*.tsv
## into components/pbpko-vocab.owl via ROBOT template.
## Logical axioms (existential restrictions) are authored in pbpko-edit.owl (Protege).
##
## Rebuild vocab component after TSV edits:
##   sh run.sh make recreate-vocab-from-template
##
## One-time seed of axioms from legacy monolith into edit file:
##   python3 src/scripts/extract_pbpko_from_original.py --seed-edit-axioms
##
## Regenerate TSV templates from legacy monolith (audit only; does not overwrite edit axioms):
##   python3 src/scripts/extract_pbpko_from_original.py

.PHONY: recreate-vocab-from-template

TEMPLATE_SEED = template-seed.owl
VOCAB_TEMPLATES = $(TEMPLATEDIR)/pbpko-properties.tsv \
	$(TEMPLATEDIR)/pbpko-vocab.tsv

recreate-vocab-from-template: $(TEMPLATE_SEED) $(VOCAB_TEMPLATES)
	$(ROBOT) template --input $(TEMPLATE_SEED) --add-prefixes config/context.json \
	 --template $(TEMPLATEDIR)/pbpko-properties.tsv \
	 --template $(TEMPLATEDIR)/pbpko-vocab.tsv \
	 annotate --ontology-iri http://purl.obolibrary.org/obo/pbpko/components/pbpko-vocab.owl \
	 --output $(COMPONENTSDIR)/pbpko-vocab.owl.tmp.owl && \
	 mv $(COMPONENTSDIR)/pbpko-vocab.owl.tmp.owl $(COMPONENTSDIR)/pbpko-vocab.owl
