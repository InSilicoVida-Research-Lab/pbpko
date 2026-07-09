#!/usr/bin/env python3
"""Backfill releases/YYYY-MM-DD/pbpko.owl snapshots from historical git tags."""

from __future__ import annotations

import re
import subprocess
from pathlib import Path

# Official OBO release dates mapped to the latest semver tag for that date.
RELEASES: list[tuple[str, str]] = [
    ("2024-07-15", "v1.0.0"),
    ("2024-10-09", "v1.0.1"),
    ("2025-02-04", "v1.1.0"),
    ("2025-05-22", "v1.2.0"),
    ("2025-09-12", "v1.3.0"),
    ("2025-10-19", "v1.3.1"),
    ("2026-02-16", "v1.3.2"),
]

OWL_PATH = "Robot/ontologies/pbpko.owl"
VERSION_IRI_TEMPLATE = "http://purl.obolibrary.org/obo/pbpko/releases/{date}/pbpko.owl"


def git_show(tag: str, path: str) -> str:
    result = subprocess.run(
        ["git", "show", f"{tag}:{path}"],
        check=True,
        capture_output=True,
    )
    return result.stdout.decode("utf-8")


def patch_version_metadata(content: str, date: str) -> str:
    version_iri = VERSION_IRI_TEMPLATE.format(date=date)
    if '<owl:versionIRI rdf:resource="' in content:
        content = re.sub(
            r'<owl:versionIRI rdf:resource="[^"]*"/>',
            f'<owl:versionIRI rdf:resource="{version_iri}"/>',
            content,
            count=1,
        )
    else:
        content = content.replace(
            '<owl:Ontology rdf:about="http://purl.obolibrary.org/obo/pbpko.owl">',
            '<owl:Ontology rdf:about="http://purl.obolibrary.org/obo/pbpko.owl">\n'
            f'        <owl:versionIRI rdf:resource="{version_iri}"/>',
            1,
        )

    if "<owl:versionInfo>" in content:
        content = re.sub(
            r"<owl:versionInfo>[^<]*</owl:versionInfo>",
            f"<owl:versionInfo>{date}</owl:versionInfo>",
            content,
            count=1,
        )
    else:
        content = content.replace(
            "</owl:Ontology>",
            f'        <owl:versionInfo>{date}</owl:versionInfo>\n    </owl:Ontology>',
            1,
        )

    if '<term:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#date">' in content:
        content = re.sub(
            r'<term:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#date">[^<]*</term:modified>',
            f'<term:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#date">{date}</term:modified>',
            content,
            count=1,
        )

    return content


def main() -> None:
    repo_root = Path(__file__).resolve().parents[1]
    releases_root = repo_root / "releases"

    for date, tag in RELEASES:
        release_dir = releases_root / date
        release_dir.mkdir(parents=True, exist_ok=True)
        output_file = release_dir / "pbpko.owl"

        print(f"Backfilling {date} from {tag} -> {output_file.relative_to(repo_root)}")
        content = git_show(tag, OWL_PATH)
        output_file.write_text(patch_version_metadata(content, date), encoding="utf-8")


if __name__ == "__main__":
    main()
