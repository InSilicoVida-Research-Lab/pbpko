#!/usr/bin/env python3
"""
Extract PBPKO native terms from the legacy Protege monolith into ODK ROBOT templates.

Reads:  orginal pbpk owl/pbpko.owl  (OWL Functional Syntax XML, read-only reference)
Writes: src/templates/pbpko-vocab.tsv
        src/templates/pbpko-properties.tsv
        src/templates/pbpko-axioms.tsv  (seed record only; axioms live in pbpko-edit.owl)
        src/ontology/template-seed.owl
        src/ontology/reports/extraction-inventory.tsv

Usage (from target/pbpko/):
  python3 src/scripts/extract_pbpko_from_original.py
  python3 src/scripts/extract_pbpko_from_original.py --seed-edit-axioms
  python3 src/scripts/extract_pbpko_from_original.py --seed-edit-axioms --force
"""

from __future__ import annotations

import argparse
import csv
import re
import sys
import xml.etree.ElementTree as ET
from collections import defaultdict
from pathlib import Path

OWL = "http://www.w3.org/2002/07/owl#"
OBO = "http://purl.obolibrary.org/obo/"
OBOINOWL = "http://www.geneontology.org/formats/oboInOwl#"

ROOT = Path(__file__).resolve().parents[2]
ORIGINAL = ROOT / "orginal pbpk owl" / "pbpko.owl"
EXISTING_VOCAB = ROOT / "src" / "templates" / "pbpko-vocab.tsv"
OUT_VOCAB = ROOT / "src" / "templates" / "pbpko-vocab.tsv"
OUT_PROPERTIES = ROOT / "src" / "templates" / "pbpko-properties.tsv"
OUT_AXIOMS = ROOT / "src" / "templates" / "pbpko-axioms.tsv"
OUT_SEED = ROOT / "src" / "ontology" / "template-seed.owl"
OUT_INVENTORY = ROOT / "src" / "ontology" / "reports" / "extraction-inventory.tsv"
EDIT_FILE = ROOT / "src" / "ontology" / "pbpko-edit.owl"

AXIOMS_SECTION_BEGIN = "# --- seeded logical axioms (edit below in Protege) ---"
AXIOMS_SECTION_END = "# --- end seeded logical axioms ---"

PROPERTY_IDS = {
    f"{OBO}PBPKO_{n}"
    for n in ("10001", "10002", "10004", "10005", "10006", "10007", "10008", "10009")
}

VOCAB_HEADER = [
    "ID",
    "Label",
    "Exact Match",
    "Synonyms",
    "Suggested parent term",
    "Abbreviation",
    "Definition",
    "Textual Definition",
    "Definition Source",
    "See Also",
    "Editor",
    "Reviewer1",
    "Reviewer2",
    "Type",
    "Parent",
    "Close Match",
    "Exact Match.1",
    "Narrow Match",
    "Related Match",
]

VOCAB_TEMPLATE = [
    "ID",
    "A rdfs:label",
    "A skos:exactMatch  SPLIT=|",
    "",
    "",
    "A oboInOwl:hasSynonymType",
    "",
    "A IAO:0000115",
    ">A IAO:0000119",
    ">AI rdfs:seeAlso",
    "A IAO:0000117",
    "A IAO:0000117",
    "A IAO:0000117",
    "TYPE",
    "SC %",
    "A skos:closeMatch",
    "A skos:exactMatch",
    "A skos:narrowMatch SPLIT=|",
    "A skos:relatedMatch SPLIT=|",
]

PROPS_HEADER = ["ID", "Label", "Definition", "Type", "Parent"]
PROPS_TEMPLATE = ["ID", "A rdfs:label", "A IAO:0000115", "TYPE", "SP %"]

AXIOMS_HEADER = ["ID", "SubClass Of"]
AXIOMS_TEMPLATE = ["ID", "SC %"]


def local(tag: str) -> str:
    return tag.split("}")[-1] if "}" in tag else tag


def resolve_iri(value: str | None) -> str | None:
    if not value:
        return None
    value = value.strip()
    if value.startswith("http://") or value.startswith("https://"):
        return value
    if value.startswith("obo:"):
        return OBO + value[4:]
    return value


def get_iri(elem: ET.Element | None) -> str | None:
    if elem is None:
        return None
    for attr in ("abbreviatedIRI", "IRI"):
        value = elem.get(attr)
        if value:
            return resolve_iri(value)
    if local(elem.tag) == "AbbreviatedIRI" and elem.text:
        return resolve_iri(elem.text.strip())
    return None


def pbpko_id(iri: str) -> str:
    return iri.rsplit("/", 1)[-1]


def curie(iri: str) -> str:
    if iri.startswith(OBO):
        local_id = iri[len(OBO) :]
        if "_" in local_id:
            prefix, rest = local_id.split("_", 1)
            return f"{prefix}:{rest}"
        return local_id
    return iri


def template_id(iri: str) -> str:
    return f"pbpko:{pbpko_id(iri)}"


def sanitize_slug(text: str) -> str:
    text = re.sub(r"\s+", "_", text.strip())
    text = re.sub(r"[^\w\-]+", "_", text)
    text = re.sub(r"_+", "_", text).strip("_")
    return text or "term"


def load_existing_labels() -> dict[str, str]:
    labels: dict[str, str] = {}
    if not EXISTING_VOCAB.exists():
        return labels
    with EXISTING_VOCAB.open(newline="", encoding="utf-8") as handle:
        reader = csv.DictReader(handle, delimiter="\t")
        for row in reader:
            term_id = row.get("ID", "")
            label = row.get("Label", "")
            if term_id and label:
                labels[term_id] = label
    return labels


def parse_original() -> tuple[
    set[str],
    set[str],
    dict[str, dict[str, list]],
    dict[str, dict[str, set]],
]:
    root = ET.parse(ORIGINAL).getroot()

    classes: set[str] = set()
    obj_props: set[str] = set()
    annotations: dict[str, dict[str, list]] = defaultdict(lambda: defaultdict(list))
    axioms: dict[str, dict[str, set]] = defaultdict(lambda: {"named": set(), "some": set(), "subprop": set()})

    for child in root:
        tag = local(child.tag)

        if tag == "Declaration":
            for decl in child:
                iri = get_iri(decl)
                if not iri or "PBPKO_" not in iri:
                    continue
                if local(decl.tag) == "Class":
                    classes.add(iri)
                elif local(decl.tag) == "ObjectProperty":
                    obj_props.add(iri)

        elif tag == "SubClassOf":
            parts = list(child)
            if len(parts) < 2:
                continue
            subj = get_iri(parts[0])
            if not subj or "PBPKO_" not in subj or subj in PROPERTY_IDS:
                continue
            sup_elem = parts[1]
            if local(sup_elem.tag) == "Class":
                sup = get_iri(sup_elem)
                if sup:
                    axioms[subj]["named"].add(sup)
            elif local(sup_elem.tag) == "ObjectSomeValuesFrom":
                prop = get_iri(sup_elem.find(f"{{{OWL}}}ObjectProperty"))
                filler = get_iri(sup_elem.find(f"{{{OWL}}}Class"))
                if prop and filler:
                    axioms[subj]["some"].add((prop, filler))

        elif tag == "SubObjectPropertyOf":
            parts = list(child)
            if len(parts) < 2:
                continue
            subj = get_iri(parts[0])
            sup = get_iri(parts[1])
            if subj and sup and subj in PROPERTY_IDS:
                axioms[subj]["subprop"].add(sup)

        elif tag == "AnnotationAssertion":
            parts = list(child)
            if len(parts) < 3:
                continue
            ap = get_iri(parts[0])
            subj = get_iri(parts[1])
            if not subj or "PBPKO_" not in subj:
                continue
            val_elem = parts[2]
            if local(val_elem.tag) == "Literal":
                val = val_elem.text or ""
            else:
                val = get_iri(val_elem) or ""
            if ap:
                key = ap
                if ap.startswith(OBO):
                    key = ap.replace(OBO, "")
                annotations[subj][key].append(val)

    # Include annotated entities not explicitly declared
    for iri in annotations:
        if iri in PROPERTY_IDS:
            obj_props.add(iri)
        elif "PBPKO_" in iri:
            classes.add(iri)

    return classes, obj_props, annotations, axioms


def pick_label(
    iri: str,
    annotations: dict[str, list],
) -> str:
    for key in ("rdfs:label",):
        if key in annotations and annotations[key]:
            return annotations[key][0].strip()
    return pbpko_id(iri)


def dedupe_preserve(seq: list[str]) -> list[str]:
    seen: set[str] = set()
    out: list[str] = []
    for item in seq:
        norm = item.strip()
        if not norm or norm in seen:
            continue
        seen.add(norm)
        out.append(norm)
    return out


def join_pipe(values: list[str]) -> str:
    return "|".join(dedupe_preserve(values))


def parent_ref(
    parent_iri: str,
    id_to_label: dict[str, str],
) -> str:
    if parent_iri.startswith(OBO) and parent_iri in id_to_label:
        return id_to_label[parent_iri]
    return parent_iri


def manchester_some(
    prop_iri: str,
    filler_iri: str,
    prop_labels: dict[str, str],
    id_to_label: dict[str, str],
) -> str:
    prop_label = prop_labels.get(prop_iri, pbpko_id(prop_iri))
    if filler_iri.startswith(OBO) and filler_iri in id_to_label:
        filler = f"'{id_to_label[filler_iri]}'"
    elif filler_iri.startswith(OBO):
        filler = curie(filler_iri)
    else:
        filler = f"<{filler_iri}>"
    return f"'{prop_label}' some {filler}"


SBO_KM_PARENT = "http://biomodels.net/SBO/SBO_0000027"
BIOCHEMICAL_PARAMETER_LABEL = "biochemical parameter"


def apply_import_policy(
    iri: str,
    parent: str,
    id_to_label: dict[str, str],
) -> str:
    """Apply docs/import-policy.md: SBO structural parents -> native PBPKO class."""
    if parent == SBO_KM_PARENT or parent.endswith("SBO_0000027"):
        return BIOCHEMICAL_PARAMETER_LABEL
    return parent


def quote_parent_for_template(parent: str) -> str:
    """Quote label-based parent refs for ROBOT Manchester SC % parsing."""
    if not parent or parent.startswith("http"):
        return parent
    if " " in parent or "-" in parent:
        return f"'{parent}'"
    return parent


def write_tsv(path: Path, header: list[str], template: list[str], rows: list[list[str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.writer(handle, delimiter="\t", lineterminator="\n", quoting=csv.QUOTE_MINIMAL)
        writer.writerow(header)
        writer.writerow(template)
        writer.writerows(rows)


def collect_some_axioms(
    classes: set[str],
    axioms: dict[str, dict[str, set]],
) -> list[tuple[str, str, str]]:
    """Return sorted (subject, property, filler) existential restriction triples."""
    triples: list[tuple[str, str, str]] = []
    for iri in sorted(classes, key=pbpko_id):
        for prop, filler in sorted(axioms.get(iri, {}).get("some", set())):
            triples.append((iri, prop, filler))
    return triples


def format_some_axiom_ofn(subj: str, prop: str, filler: str) -> str:
    """OWL Functional Syntax SubClassOf with ObjectSomeValuesFrom (full IRIs)."""
    return f"SubClassOf(<{subj}> ObjectSomeValuesFrom(<{prop}> <{filler}>))"


def build_axioms_section(triples: list[tuple[str, str, str]]) -> str:
    lines = [
        "############################",
        "#   Logical axioms",
        "#   Edit in Protege on pbpko-edit.owl (standard ODK workflow).",
        AXIOMS_SECTION_BEGIN,
        "",
    ]
    current_subj = ""
    for subj, prop, filler in triples:
        if subj != current_subj:
            if current_subj:
                lines.append("")
            lines.append(f"# {pbpko_id(subj)}")
            current_subj = subj
        lines.append(format_some_axiom_ofn(subj, prop, filler))
    lines.extend(["", AXIOMS_SECTION_END, ""])
    return "\n".join(lines)


def seed_edit_axioms(force: bool = False) -> int:
    """One-time (or --force) injection of existential axioms into pbpko-edit.owl."""
    if not ORIGINAL.exists():
        print(f"ERROR: original ontology not found: {ORIGINAL}", file=sys.stderr)
        return 1
    if not EDIT_FILE.exists():
        print(f"ERROR: edit file not found: {EDIT_FILE}", file=sys.stderr)
        return 1

    edit_text = EDIT_FILE.read_text(encoding="utf-8")
    if AXIOMS_SECTION_BEGIN in edit_text and not force:
        print(
            f"SKIP: {EDIT_FILE.name} already contains seeded axioms. "
            "Use --force to overwrite the axioms section."
        )
        return 0

    classes, _, _, axioms = parse_original()
    triples = collect_some_axioms(classes, axioms)
    section = build_axioms_section(triples)

    if AXIOMS_SECTION_BEGIN in edit_text:
        start = edit_text.index(AXIOMS_SECTION_BEGIN)
        end = edit_text.index(AXIOMS_SECTION_END) + len(AXIOMS_SECTION_END)
        # Include header block back to ############################ if present
        header_start = edit_text.rfind("############################", 0, start)
        if header_start >= 0 and header_start > len(edit_text) - 500000:
            start = header_start
        before = edit_text[:start].rstrip()
        after = edit_text[end:].lstrip()
        new_text = before + "\n\n" + section + after
    else:
        # Insert before closing parenthesis of Ontology(...)
        close_idx = edit_text.rfind("\n)")
        if close_idx < 0:
            print("ERROR: could not find closing ')' in edit file", file=sys.stderr)
            return 1
        before = edit_text[:close_idx].rstrip()
        after = edit_text[close_idx:]
        new_text = before + "\n\n" + section + after

    EDIT_FILE.write_text(new_text, encoding="utf-8")
    print(f"Seeded {len(triples)} existential axioms into {EDIT_FILE}")
    return 0


def write_minimal_seed(path: Path) -> None:
    content = """<?xml version="1.0"?>
<Ontology xmlns="http://www.w3.org/2002/07/owl#"
     xml:base="http://purl.obolibrary.org/obo/pbpko/template-seed.owl"
     ontologyIRI="http://purl.obolibrary.org/obo/pbpko/template-seed.owl">
    <Prefix name="" IRI="http://purl.obolibrary.org/obo/pbpko/template-seed.owl#"/>
    <Prefix name="obo" IRI="http://purl.obolibrary.org/obo/"/>
    <Prefix name="owl" IRI="http://www.w3.org/2002/07/owl#"/>
    <Prefix name="rdf" IRI="http://www.w3.org/1999/02/22-rdf-syntax-ns#"/>
    <Prefix name="rdfs" IRI="http://www.w3.org/2000/01/rdf-schema#"/>
    <Annotation>
        <AnnotationProperty abbreviatedIRI="rdfs:comment"/>
        <Literal>Minimal ROBOT template seed for PBPKO. Native terms are generated from src/templates/*.tsv. Do not copy build output into this file.</Literal>
    </Annotation>
</Ontology>
"""
    path.write_text(content, encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description="Extract PBPKO templates from legacy OWL")
    parser.add_argument(
        "--seed-edit-axioms",
        action="store_true",
        help="Inject existential axioms into pbpko-edit.owl (one-time seed for Protege editing)",
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="With --seed-edit-axioms, overwrite existing axioms section",
    )
    parser.add_argument(
        "--templates-only",
        action="store_true",
        help="Only regenerate TSV templates (skip edit-file seeding unless --seed-edit-axioms)",
    )
    args = parser.parse_args()

    if args.seed_edit_axioms and args.templates_only:
        return seed_edit_axioms(force=args.force)

    if args.seed_edit_axioms:
        rc = seed_edit_axioms(force=args.force)
        if rc != 0:
            return rc

    if not ORIGINAL.exists():
        print(f"ERROR: original ontology not found: {ORIGINAL}", file=sys.stderr)
        return 1

    existing_labels = load_existing_labels()
    classes, obj_props, annotations, axioms = parse_original()

    # Build label map for all PBPKO classes (rdfs:label used for SC % parent refs)
    id_to_label: dict[str, str] = {}
    for iri in sorted(classes):
        ann = annotations.get(iri, {})
        id_to_label[iri] = pick_label(iri, ann)

    prop_labels: dict[str, str] = {}
    for iri in sorted(obj_props):
        ann = annotations.get(iri, {})
        label = ann.get("rdfs:label", [pbpko_id(iri)])[0]
        prop_labels[iri] = label

    # --- vocab rows ---
    vocab_rows: list[list[str]] = []
    inventory_rows: list[list[str]] = []

    for iri in sorted(classes, key=lambda x: pbpko_id(x)):
        ann = annotations.get(iri, {})
        label_value = id_to_label[iri]

        synonyms = dedupe_preserve(ann.get("IAO_0000118", []))
        # Remove synonyms identical to label (case-insensitive) to avoid duplicate_exact_synonym WARN
        label_lower = label_value.lower()
        synonyms = [s for s in synonyms if s.lower() != label_lower]

        definitions = dedupe_preserve(ann.get("IAO_0000115", []))
        def_sources = dedupe_preserve(ann.get("IAO_0000119", []))
        see_also = dedupe_preserve(ann.get("rdfs:seeAlso", []))

        editors = dedupe_preserve(ann.get("IAO_0000117", []))
        editor = editors[0] if len(editors) > 0 else ""
        reviewer1 = editors[1] if len(editors) > 1 else ""
        reviewer2 = editors[2] if len(editors) > 2 else ""

        exact_match = dedupe_preserve(
            ann.get("core:exactMatch", []) + ann.get("skos:exactMatch", [])
        )
        close_match = dedupe_preserve(
            ann.get("core:closeMatch", []) + ann.get("skos:closeMatch", [])
        )
        narrow_match = dedupe_preserve(ann.get("core:narrowMatch", []) + ann.get("skos:narrowMatch", []))
        related_match = dedupe_preserve(ann.get("core:relatedMatch", []) + ann.get("skos:relatedMatch", []))

        # Choose primary named parent (prefer PBPKO over foreign if multiple)
        named_parents = axioms.get(iri, {}).get("named", set())
        parent = ""
        if named_parents:
            pbpko_parents = [p for p in named_parents if p.startswith(OBO) and p in id_to_label]
            foreign_parents = [p for p in named_parents if p not in pbpko_parents]
            chosen = pbpko_parents[0] if pbpko_parents else (sorted(foreign_parents)[0] if foreign_parents else "")
            if chosen:
                parent = apply_import_policy(iri, parent_ref(chosen, id_to_label), id_to_label)
                parent = quote_parent_for_template(parent)

        vocab_rows.append(
            [
                template_id(iri),
                label_value,
                join_pipe(exact_match),
                join_pipe(synonyms),
                "",
                join_pipe(synonyms[:1]) if synonyms else "",
                definitions[0] if definitions else "",
                definitions[0] if definitions else "",
                join_pipe(def_sources),
                join_pipe(see_also),
                editor,
                reviewer1,
                reviewer2,
                "Class",
                parent,
                join_pipe(close_match),
                join_pipe(exact_match),
                join_pipe(narrow_match),
                join_pipe(related_match),
            ]
        )

        inventory_rows.append(
            [
                template_id(iri),
                label_value,
                label_value,
                parent,
                str(len(axioms.get(iri, {}).get("some", set()))),
                "existing" if template_id(iri) in existing_labels else "new",
            ]
        )

    write_tsv(OUT_VOCAB, VOCAB_HEADER, VOCAB_TEMPLATE, vocab_rows)

    # --- properties rows ---
    prop_rows: list[list[str]] = []
    for iri in sorted(obj_props, key=lambda x: pbpko_id(x)):
        ann = annotations.get(iri, {})
        label = ann.get("rdfs:label", [pbpko_id(iri)])[0]
        definition = ann.get("IAO_0000115", [""])[0]
        subprops = axioms.get(iri, {}).get("subprop", set())
        if subprops:
            sup = sorted(subprops)[0]
            if sup.startswith(OBO) and sup in prop_labels:
                parent = quote_parent_for_template(prop_labels[sup])
            else:
                parent = sup
        else:
            parent = OBO + "BFO_0000051"
        prop_rows.append(
            [
                template_id(iri),
                label,
                definition,
                "Object Property",
                parent,
            ]
        )

    write_tsv(OUT_PROPERTIES, PROPS_HEADER, PROPS_TEMPLATE, prop_rows)

    # --- axioms rows (existential restrictions only) ---
    axiom_rows: list[list[str]] = []
    for iri in sorted(classes, key=lambda x: pbpko_id(x)):
        some_axioms = axioms.get(iri, {}).get("some", set())
        for prop, filler in sorted(some_axioms):
            axiom_rows.append(
                [
                    template_id(iri),
                    manchester_some(prop, filler, prop_labels, id_to_label),
                ]
            )

    write_tsv(OUT_AXIOMS, AXIOMS_HEADER, AXIOMS_TEMPLATE, axiom_rows)

    write_minimal_seed(OUT_SEED)

    OUT_INVENTORY.parent.mkdir(parents=True, exist_ok=True)
    with OUT_INVENTORY.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.writer(handle, delimiter="\t", lineterminator="\n")
        writer.writerow(["ID", "Label", "RdfsLabel", "Parent", "SomeAxiomCount", "Status"])
        writer.writerows(inventory_rows)

    new_count = sum(1 for row in inventory_rows if row[5] == "new")
    print(f"Extracted {len(classes)} classes, {len(obj_props)} object properties")
    print(f"Axioms rows: {len(axiom_rows)}")
    print(f"New vs existing TSV labels: {new_count} new, {len(classes) - new_count} retained slugs")
    print(f"Wrote {OUT_VOCAB}")
    print(f"Wrote {OUT_PROPERTIES}")
    print(f"Wrote {OUT_AXIOMS}")
    print(f"Wrote {OUT_SEED}")
    print(f"Wrote {OUT_INVENTORY}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
