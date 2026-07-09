#!/usr/bin/env bash
# Remove top-level orphan rdf:Description nodes after the last OWL axiom.
set -euo pipefail

OWL_FILE="${1:?usage: clean-owl-orphans.sh <path-to.owl>}"

python3 - "${OWL_FILE}" <<'PY'
import re
import sys
from pathlib import Path

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")

if "</rdf:RDF>" not in text:
    raise SystemExit(f"not an RDF/XML file: {path}")

body, suffix = text.split("</rdf:RDF>", 1)

last_axiom_end = -1
for tag in ("</owl:Class>", "</owl:ObjectProperty>", "</owl:DatatypeProperty>", "</owl:AnnotationProperty>"):
    idx = body.rfind(tag)
    if idx > last_axiom_end:
        last_axiom_end = idx + len(tag)

if last_axiom_end < 0:
    print(f"No OWL axioms found in {path}; skipping orphan cleanup")
    raise SystemExit(0)

prefix = body[:last_axiom_end]
tail = body[last_axiom_end:]
cleaned_tail = re.sub(
    r"(\s*<rdf:Description\b[^>]*>.*?</rdf:Description>)+\s*",
    "\n",
    tail,
    flags=re.DOTALL,
)

if cleaned_tail != tail:
    path.write_text(prefix + cleaned_tail + "</rdf:RDF>" + suffix, encoding="utf-8")
    print(f"Removed orphan rdf:Description nodes from {path}")
PY
