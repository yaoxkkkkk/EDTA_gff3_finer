#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage:"
  echo "  $0 -g EDTA.gff3 -o TE_ontology.txt -t TE_type.txt -out output.bed"
  exit 1
}

GFF=""
ONTOLOGY=""
TYPE=""
OUT=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -g)   GFF="$2"; shift 2 ;;
    -o)   ONTOLOGY="$2"; shift 2 ;;
    -t)   TYPE="$2"; shift 2 ;;
    -out) OUT="$2"; shift 2 ;;
    *) usage ;;
  esac
done

if [[ -z "$GFF" || -z "$ONTOLOGY" || -z "$TYPE" || -z "$OUT" ]]; then
  usage
fi

awk -F'\t' '
BEGIN{OFS="\t"}

FNR==NR {
  split($2, a, ",")
  for (i in a) {
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", a[i])
    ontology_map[a[i]] = $1
  }
  next
}

FILENAME==type_file {
  if (NF < 3) next
  if ($1 ~ /^Classification$/ && $2 ~ /^Order$/ && $3 ~ /^Superfamily$/) next

  key = $3
  class_map[key] = $1
  order_map[key] = $2
  next
}

FILENAME==gff_file {
  if ($0 ~ /^#/ || NF < 9) next

  chr   = $1
  start = $4 - 1
  end   = $5

  edta_class = "Unknown"
  split($9, attr, ";")
  for (i in attr) {
    if (attr[i] ~ /^classification=/) {
      split(attr[i], b, "=")
      edta_class = b[2]
      break
    }
  }

  ontology = (edta_class in ontology_map) ? ontology_map[edta_class] : "Unknown"

  superfamily = ontology
  if (ontology != "Unknown" && (ontology in class_map)) {
    classification = class_map[ontology]
    order = order_map[ontology]
  } else {
    classification = "Unknown"
    order = "Unknown"
  }

  print chr, start, end, edta_class, superfamily, order, classification
}
' gff_file="$GFF" type_file="$TYPE" \
  "$ONTOLOGY" "$TYPE" "$GFF" > "$OUT"

echo "✔ Done. Annotated BED written to: $OUT"
