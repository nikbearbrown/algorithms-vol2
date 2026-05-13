#!/usr/bin/env bash
# rename_chapters.sh  —  bash 3.2 compatible (macOS default)
# Renames every .md in chapters/ to NN-kebab-case-title.md
# Usage: bash rename_chapters.sh [path/to/chapters]   (default: ./chapters)

CHAPTERS_DIR="${1:-./chapters}"
UNRESOLVED_DIR="${CHAPTERS_DIR}/_unresolved"

if [[ ! -d "$CHAPTERS_DIR" ]]; then
  echo "ERROR: Directory not found: $CHAPTERS_DIR" >&2
  exit 1
fi

mkdir -p "$UNRESOLVED_DIR"

# Temp files replace associative arrays
PAIRS_FILE=$(mktemp /tmp/ch_pairs.XXXXXX)    # "src|target_basename" per line
SEEN_FILE=$(mktemp /tmp/ch_seen.XXXXXX)      # "target|src" per line
trap 'rm -f "$PAIRS_FILE" "$SEEN_FILE"' EXIT

# ── helper: slugify a title string ────────────────────────────────────────
slugify() {
  echo "$1" \
    | sed 's/&/ and /g' \
    | sed 's/[–—]/ /g' \
    | sed 's/://g' \
    | tr '[:upper:]' '[:lower:]' \
    | tr -cd 'a-z0-9 ' \
    | tr -s ' ' '-' \
    | sed 's/^-//;s/-$//'
}

# ── first pass: build src|target pairs ────────────────────────────────────
max_chapter=0
epilogue_src=""
epilogue_h1=""

for f in "$CHAPTERS_DIR"/*.md; do
  [[ -e "$f" ]] || continue
  [[ "$f" == */_unresolved/* ]] && continue

  bn="$(basename "$f")"
  h1=$(grep -m1 '^# ' "$f" 2>/dev/null || true)

  if [[ -z "$h1" ]]; then
    echo "SKIP  (no H1): $bn"
    continue
  fi

  title="${h1#\# }"
  title_lower=$(echo "$title" | tr '[:upper:]' '[:lower:]')

  # ── frontmatter ─────────────────────────────────────────────────────
  if echo "$title_lower" | grep -q 'frontmatter\|front matter'; then
    echo "$f|00-frontmatter.md" >> "$PAIRS_FILE"
    continue
  fi

  # ── epilogue (deferred) ──────────────────────────────────────────────
  if echo "$title_lower" | grep -q 'epilogue'; then
    epilogue_src="$f"
    epilogue_h1="$title"
    continue
  fi

  # ── extract chapter number ───────────────────────────────────────────
  num=""
  slug_title=""

  if echo "$title" | grep -qiE '^[Cc]hapter[[:space:]]+[0-9]+'; then
    num=$(echo "$title" | sed -E 's/^[Cc]hapter[[:space:]]+([0-9]+).*/\1/')
    slug_title=$(echo "$title" | sed -E 's/^[Cc]hapter[[:space:]]+[0-9]+[[:space:]:.\-]*//')
  elif echo "$title" | grep -qE '^[0-9]+[[:space:][:punct:]]'; then
    num=$(echo "$title" | sed -E 's/^([0-9]+).*/\1/')
    slug_title=$(echo "$title" | sed -E 's/^[0-9]+[[:space:][:punct:]]*//')
  elif echo "$bn" | grep -qE 'chapter-([0-9]+)'; then
    num=$(echo "$bn" | sed -E 's/.*chapter-([0-9]+).*/\1/')
    slug_title="$title"
  else
    echo "SKIP  (no chapter number in H1 or filename): $bn"
    continue
  fi

  num_padded=$(printf '%02d' "$((10#$num))")
  [[ "$((10#$num))" -gt "$max_chapter" ]] && max_chapter="$((10#$num))"

  [[ -z "$slug_title" ]] && slug_title="$title"
  slug=$(slugify "$slug_title")
  echo "$f|${num_padded}-${slug}.md" >> "$PAIRS_FILE"
done

# ── assign epilogue number ─────────────────────────────────────────────────
if [[ -n "$epilogue_src" ]]; then
  epi_num=$(printf '%02d' $(( max_chapter + 1 )) )
  slug=$(slugify "$epilogue_h1")
  echo "$epilogue_src|${epi_num}-${slug}.md" >> "$PAIRS_FILE"
fi

# ── second pass: detect collisions ────────────────────────────────────────
while IFS='|' read -r src target; do
  claimed=$(grep "^${target}|" "$SEEN_FILE" | head -1 | cut -d'|' -f2)
  if [[ -n "$claimed" ]]; then
    echo "COLLISION : $target"
    echo "  KEEPING : $(basename "$claimed")"
    echo "  MOVING  : $(basename "$src") → _unresolved/"
    mv "$src" "$UNRESOLVED_DIR/$(basename "$src")"
  else
    echo "${target}|${src}" >> "$SEEN_FILE"
  fi
done < "$PAIRS_FILE"

# ── third pass: rename ────────────────────────────────────────────────────
while IFS='|' read -r target src; do
  dest="${CHAPTERS_DIR}/${target}"
  if [[ "$src" == "$dest" ]]; then
    echo "UNCHANGED : $(basename "$src")"
  elif [[ -e "$src" ]]; then
    echo "RENAME    : $(basename "$src")  →  ${target}"
    mv "$src" "$dest"
  fi
done < "$SEEN_FILE"

# ── final listing ─────────────────────────────────────────────────────────
echo ""
echo "── Final listing: $CHAPTERS_DIR ──"
ls -1 "$CHAPTERS_DIR"

if ls "$UNRESOLVED_DIR"/* >/dev/null 2>&1; then
  echo ""
  echo "── _unresolved/ ──"
  ls -1 "$UNRESOLVED_DIR"
fi
