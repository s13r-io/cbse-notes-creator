#!/usr/bin/env bash
# quality-check.sh — Automated quality scoring for CBSE study notes
# Compatible with macOS bash 3.2 (no associative arrays)
# Usage: ./quality-check.sh <file1.md> [<file2.md> ...]
#        ./quality-check.sh <dir1> <dir2>  (compare two directories)
set -uo pipefail

# Temp file for score storage
SCORES_DIR=$(mktemp -d)
trap 'rm -rf "$SCORES_DIR"' EXIT

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Subject-to-wordcount mapping via function
get_wc_range() {
    local subject="$1"
    case "$subject" in
        maths)     echo "5000 7000" ;;
        science)   echo "6000 9000" ;;
        english)   echo "6000 9000" ;;
        history)   echo "7000 10000" ;;
        geography) echo "6000 9000" ;;
        economics) echo "6000 9000" ;;
        civics)    echo "6000 9000" ;;
        *)         echo "5000 15000" ;;
    esac
}

# Subject mapping from filename
detect_subject() {
    local f
    f=$(basename "$1" .md | tr '[:upper:]' '[:lower:]')
    case "$f" in
        *euclid*|*geometry*|*maths*)           echo "maths" ;;
        *fundamental*unit*|*life*|*cell*|*biology*|*science*) echo "science" ;;
        *little_girl*|*rain*roof*|*english*|*girl*)  echo "english" ;;
        *french_revolution*|*history*)          echo "history" ;;
        *climate*|*geography*)                  echo "geography" ;;
        *food_security*|*economics*)            echo "economics" ;;
        *constitutional*|*civics*|*political*)  echo "civics" ;;
        *)                                      echo "unknown" ;;
    esac
}

# Get line number of first match
section_line() {
    grep -n "$2" "$1" 2>/dev/null | head -1 | cut -d: -f1
}

# Extract text between two line numbers
extract_range() {
    if [ -z "$2" ] || [ -z "$3" ]; then echo ""; return; fi
    sed -n "${2},${3}p" "$1"
}

score_file() {
    local file="$1"
    local subject
    subject=$(detect_subject "$file")

    echo -e "${BLUE}Scoring: $(basename "$file")${NC} (subject: $subject)"
    echo ""

    local total_score=0
    local total_lines
    total_lines=$(wc -l < "$file" | tr -d ' ')

    # Section line numbers
    local sec1_line sec2_line sec3_line sec4_line sec5_line sec6_line sec7_line
    sec1_line=$(section_line "$file" "Chapter Introduction\|Chapter Overview\|## 1\.")
    sec2_line=$(section_line "$file" "Key Terms\|## 2\.")
    sec3_line=$(section_line "$file" "Core Content\|## 3\.")
    sec4_line=$(section_line "$file" "Common Mistakes\|## 4\.")
    sec5_line=$(section_line "$file" "Concept Connections\|How This\|## 5\.")
    sec6_line=$(section_line "$file" "Quick Revision\|## 6\.")
    sec7_line=$(section_line "$file" "Questions and Answers\|Questions & Answers\|## 7\.")

    # Section text extractions
    local sec1_text="" sec2_text="" cc_text="" sec4_text="" sec6_text="" sec7_text=""
    [ -n "$sec1_line" ] && [ -n "$sec2_line" ] && sec1_text=$(extract_range "$file" "$sec1_line" "$((sec2_line - 1))")
    [ -n "$sec2_line" ] && [ -n "$sec3_line" ] && sec2_text=$(extract_range "$file" "$sec2_line" "$((sec3_line - 1))")
    [ -n "$sec3_line" ] && [ -n "$sec4_line" ] && cc_text=$(extract_range "$file" "$sec3_line" "$((sec4_line - 1))")
    [ -n "$sec4_line" ] && [ -n "$sec5_line" ] && sec4_text=$(extract_range "$file" "$sec4_line" "$((sec5_line - 1))")
    [ -n "$sec6_line" ] && [ -n "$sec7_line" ] && sec6_text=$(extract_range "$file" "$sec6_line" "$((sec7_line - 1))")
    [ -n "$sec7_line" ] && sec7_text=$(extract_range "$file" "$sec7_line" "$total_lines")

    # =============================================
    # A. STRUCTURAL COMPLETENESS (25 pts)
    # =============================================
    echo -e "${YELLOW}A. Structural Completeness${NC}"

    # Check 1: All 7 sections present (10 pts)
    local sections_found=0
    grep -qi "chapter introduction\|chapter overview" "$file" 2>/dev/null && ((sections_found++))
    grep -qi "key terms" "$file" 2>/dev/null && ((sections_found++))
    grep -qi "core content" "$file" 2>/dev/null && ((sections_found++))
    grep -qi "common mistakes\|misconceptions" "$file" 2>/dev/null && ((sections_found++))
    grep -qi "concept connections\|how this chapter connect" "$file" 2>/dev/null && ((sections_found++))
    grep -qi "quick revision" "$file" 2>/dev/null && ((sections_found++))
    grep -qi "questions and answers\|questions & answers" "$file" 2>/dev/null && ((sections_found++))
    local sec_score=$sections_found
    echo "  Check 1 - Sections found: $sections_found/7 -> ${sec_score}/10 pts"
    ((total_score += sec_score))

    # Check 2: Quick Revision sub-elements (3 pts)
    local qr_score=0
    local qr_elem=0
    echo "$sec6_text" | grep -qi "top\|things to remember" && ((qr_elem++))
    echo "$sec6_text" | grep -qi "revision table\|key points" && ((qr_elem++))
    echo "$sec6_text" | grep -qi "examiner.*tip\|tips.*chapter" && ((qr_elem++))
    [ "$qr_elem" -ge 3 ] && qr_score=3
    [ "$qr_elem" -ge 2 ] && [ "$qr_score" -lt 3 ] && qr_score=2
    [ "$qr_elem" -ge 1 ] && [ "$qr_score" -lt 2 ] && qr_score=1
    echo "  Check 2 - Quick Revision elements: $qr_elem/3 -> ${qr_score}/3 pts"
    ((total_score += qr_score))

    # Check 3: Section 1 sub-sections (2 pts)
    local s1_count=0
    echo "$sec1_text" | grep -qi "overview\|about" && ((s1_count++))
    echo "$sec1_text" | grep -qi "structure\|topic" && ((s1_count++))
    echo "$sec1_text" | grep -qi "prerequisite" && ((s1_count++))
    echo "$sec1_text" | grep -qi "matter\|important\|why" && ((s1_count++))
    local s1_score=0
    [ "$s1_count" -ge 4 ] && s1_score=2
    [ "$s1_count" -ge 2 ] && [ "$s1_score" -lt 2 ] && s1_score=1
    echo "  Check 3 - Section 1 sub-elements: $s1_count/4 -> ${s1_score}/2 pts"
    ((total_score += s1_score))

    # Check 4: Section 2 table format (2 pts)
    local t_score=0
    local t_cols=0
    local t_header
    t_header=$(echo "$sec2_text" | grep '|---' | head -1)
    if [ -n "$t_header" ]; then
        t_cols=$(echo "$t_header" | tr -cd '|' | wc -c | tr -d ' ')
    fi
    [ "$t_cols" -ge 4 ] && t_score=2
    [ "$t_cols" -ge 3 ] && [ "$t_score" -lt 2 ] && t_score=1
    echo "  Check 4 - Section 2 table: ${t_cols} cols -> ${t_score}/2 pts"
    ((total_score += t_score))

    # Check 5: Key terms count (2 pts)
    local term_count=0
    if [ -n "$sec2_text" ]; then
        term_count=$(echo "$sec2_text" | grep '|' | grep -v '|---' | grep -v '^|.*Term\|^|.*Definition\|^|.*---' | wc -l | tr -d ' ')
        [ "$term_count" -gt 0 ] && term_count=$((term_count - 1))  # subtract header
        [ "$term_count" -lt 0 ] && term_count=0
    fi
    local kt_score=0
    [ "$term_count" -ge 10 ] && [ "$term_count" -le 15 ] && kt_score=2
    [ "$term_count" -ge 7 ] && [ "$term_count" -le 20 ] && [ "$kt_score" -lt 2 ] && kt_score=1
    echo "  Check 5 - Key terms: ${term_count} (target 10-15) -> ${kt_score}/2 pts"
    ((total_score += kt_score))

    # Check 6: Core Content sub-sections (3 pts)
    local h3_count=0
    [ -n "$cc_text" ] && h3_count=$(echo "$cc_text" | grep -c '^### ' || true)
    local cc_score=0
    [ "$h3_count" -ge 3 ] && [ "$h3_count" -le 6 ] && cc_score=3
    [ "$h3_count" -ge 2 ] && [ "$h3_count" -le 8 ] && [ "$cc_score" -lt 3 ] && cc_score=2
    [ "$h3_count" -ge 1 ] && [ "$cc_score" -lt 2 ] && cc_score=1
    echo "  Check 6 - Core Content sub-sections: ${h3_count} (target 3-6) -> ${cc_score}/3 pts"
    ((total_score += cc_score))

    # Check 7: Section 4 table format (3 pts)
    local s4_rows=0 s4_cols=0
    if [ -n "$sec4_text" ]; then
        s4_rows=$(echo "$sec4_text" | grep '|' | grep -v '|---' | wc -l | tr -d ' ')
        [ "$s4_rows" -gt 0 ] && s4_rows=$((s4_rows - 1)) && [ "$s4_rows" -lt 0 ] && s4_rows=0
        local s4_header
        s4_header=$(echo "$sec4_text" | grep '|---' | head -1)
        local s4_cc
        s4_cc=$(echo "$s4_header" | tr -cd '|' | wc -c | tr -d ' ')
        [ "$s4_cc" -ge 4 ] && s4_cols=3
    fi
    local s4_score=0
    [ "$s4_cols" -ge 3 ] && [ "$s4_rows" -ge 4 ] && [ "$s4_rows" -le 8 ] && s4_score=3
    [ "$s4_cols" -ge 3 ] && [ "$s4_score" -lt 3 ] && s4_score=2
    [ "$s4_rows" -ge 4 ] && [ "$s4_score" -lt 2 ] && s4_score=1
    echo "  Check 7 - Section 4 table: ${s4_rows} rows, ${s4_cols} cols -> ${s4_score}/3 pts"
    ((total_score += s4_score))

    local struct_score=$total_score
    echo -e "  Subtotal A: ${struct_score}/25 pts"
    echo ""

    # =============================================
    # B. WORD COUNT & LENGTH (10 pts)
    # =============================================
    echo -e "${YELLOW}B. Word Count & Length${NC}"

    # Check 8: Total word count (5 pts)
    local total_wc
    total_wc=$(wc -w < "$file" | tr -d ' ')
    local wc_range
    wc_range=$(get_wc_range "$subject")
    local min_w max_w
    min_w=$(echo "$wc_range" | cut -d' ' -f1)
    max_w=$(echo "$wc_range" | cut -d' ' -f2)
    local wc_score=0
    if [ "$total_wc" -ge "$min_w" ] && [ "$total_wc" -le "$max_w" ]; then
        wc_score=5
    elif [ "$total_wc" -lt "$min_w" ]; then
        local pct_low=$(( (min_w - total_wc) * 100 / min_w ))
        [ "$pct_low" -le 20 ] && wc_score=3
        [ "$pct_low" -le 50 ] && [ "$wc_score" -lt 3 ] && wc_score=1
    else
        local pct_high=$(( (total_wc - max_w) * 100 / max_w ))
        [ "$pct_high" -le 20 ] && wc_score=3
        [ "$pct_high" -le 50 ] && [ "$wc_score" -lt 3 ] && wc_score=1
    fi
    echo "  Check 8 - Total words: ${total_wc} (target ${min_w}-${max_w}) -> ${wc_score}/5 pts"
    ((total_score += wc_score))

    # Check 9: Core Content word count (5 pts)
    local cc_wc=0 cc_pct=0
    if [ -n "$cc_text" ]; then
        cc_wc=$(echo "$cc_text" | wc -w | tr -d ' ')
    fi
    if [ "$total_wc" -gt 0 ] && [ "$cc_wc" -gt 0 ]; then
        cc_pct=$((cc_wc * 100 / total_wc))
    fi
    local cp_score=0
    [ "$cc_wc" -ge 2000 ] && cp_score=5
    [ "$cc_wc" -ge 1500 ] && [ "$cp_score" -lt 5 ] && cp_score=3
    [ "$cc_wc" -ge 800 ] && [ "$cp_score" -lt 3 ] && cp_score=1
    echo "  Check 9 - Core Content: ${cc_wc} words (${cc_pct}% of total) -> ${cp_score}/5 pts"
    ((total_score += cp_score))

    local wc_subtotal=$((wc_score + cp_score))
    echo -e "  Subtotal B: ${wc_subtotal}/10 pts"
    echo ""

    # =============================================
    # C. FORMATTING COMPLIANCE (15 pts)
    # =============================================
    echo -e "${YELLOW}C. Formatting Compliance${NC}"

    # Check 10: Bold key terms in Core Content (3 pts)
    local bold_count=0
    if [ -n "$cc_text" ]; then
        bold_count=$(echo "$cc_text" | grep -o '\*\*[^*]*\*\*' | wc -l | tr -d ' ')
    fi
    local bold_score=0
    [ "$bold_count" -ge 100 ] && bold_score=3
    [ "$bold_count" -ge 50 ] && [ "$bold_score" -lt 3 ] && bold_score=2
    [ "$bold_count" -ge 20 ] && [ "$bold_score" -lt 2 ] && bold_score=1
    echo "  Check 10 - Bold terms in CC: ${bold_count} -> ${bold_score}/3 pts"
    ((total_score += bold_score))

    # Check 11: Star markers (3 pts)
    local star_count
    star_count=$(grep -o '⭐' "$file" 2>/dev/null | wc -l | tr -d ' ')
    local star_score=0
    [ "$star_count" -ge 5 ] && star_score=3
    [ "$star_count" -ge 2 ] && [ "$star_score" -lt 3 ] && star_score=2
    [ "$star_count" -ge 1 ] && [ "$star_score" -lt 2 ] && star_score=1
    echo "  Check 11 - Stars (⭐): ${star_count} -> ${star_score}/3 pts"
    ((total_score += star_score))

    # Check 12: Triangle markers (3 pts)
    local tri_count
    tri_count=$(grep -o '△' "$file" 2>/dev/null | wc -l | tr -d ' ')
    local tri_score=0
    [ "$tri_count" -ge 3 ] && tri_score=3
    [ "$tri_count" -ge 1 ] && [ "$tri_score" -lt 3 ] && tri_score=2
    echo "  Check 12 - Triangles (△): ${tri_count} -> ${tri_score}/3 pts"
    ((total_score += tri_score))

    # Check 13: Think About It boxes (3 pts)
    local think_count
    think_count=$(grep -ci "think about it" "$file" 2>/dev/null | tail -1)
    [ -z "$think_count" ] && think_count=0
    local think_score=0
    [ "$think_count" -ge 4 ] && think_score=3
    [ "$think_count" -ge 2 ] && [ "$think_score" -lt 3 ] && think_score=2
    [ "$think_count" -ge 1 ] && [ "$think_score" -lt 2 ] && think_score=1
    echo "  Check 13 - Think About It: ${think_count} -> ${think_score}/3 pts"
    ((total_score += think_score))

    # Check 14: Horizontal rule separators (3 pts)
    local hr_count
    hr_count=$(grep -c '^---$' "$file" 2>/dev/null || echo 0)
    local hr_score=0
    [ "$hr_count" -ge 9 ] && hr_score=3
    [ "$hr_count" -ge 6 ] && [ "$hr_score" -lt 3 ] && hr_score=2
    [ "$hr_count" -ge 3 ] && [ "$hr_score" -lt 2 ] && hr_score=1
    echo "  Check 14 - Horizontal rules (---): ${hr_count} -> ${hr_score}/3 pts"
    ((total_score += hr_score))

    local fmt_subtotal=$((bold_score + star_score + tri_score + think_score + hr_score))
    echo -e "  Subtotal C: ${fmt_subtotal}/15 pts"
    echo ""

    # =============================================
    # D. QUESTION COUNTS & TYPES (15 pts)
    # =============================================
    echo -e "${YELLOW}D. Question Counts & Types${NC}"

    # Check 15: Total questions (5 pts)
    local q_count
    q_count=$(grep -c '\*\*Q[0-9]' "$file" 2>/dev/null || echo 0)
    local q_score=0
    [ "$q_count" -ge 22 ] && [ "$q_count" -le 28 ] && q_score=5
    [ "$q_count" -ge 20 ] && [ "$q_count" -le 32 ] && [ "$q_score" -lt 5 ] && q_score=4
    [ "$q_count" -ge 18 ] && [ "$q_count" -le 35 ] && [ "$q_score" -lt 4 ] && q_score=3
    [ "$q_count" -ge 14 ] && [ "$q_score" -lt 3 ] && q_score=2
    [ "$q_count" -ge 10 ] && [ "$q_score" -lt 2 ] && q_score=1
    echo "  Check 15 - Total questions: ${q_count} (target 22-28) -> ${q_score}/5 pts"
    ((total_score += q_score))

    # Check 16: MCQs (2 pts)
    local mcq_count
    mcq_count=$(grep -ci '(a)' "$file" 2>/dev/null || echo 0)
    # Subtract MCQs in answer lines (inline answers may repeat option letters)
    local mcq_score=0
    [ "$mcq_count" -ge 4 ] && mcq_score=2
    [ "$mcq_count" -ge 1 ] && [ "$mcq_score" -lt 2 ] && mcq_score=1
    echo "  Check 16 - MCQs: ${mcq_count} -> ${mcq_score}/2 pts"
    ((total_score += mcq_score))

    # Check 17: Fill-in-the-blank (2 pts)
    local fib_count
    fib_count=$(grep -o '_____\|___' "$file" 2>/dev/null | wc -l | tr -d ' ')
    local fib_score=0
    [ "$fib_count" -ge 3 ] && fib_score=2
    [ "$fib_count" -ge 1 ] && [ "$fib_score" -lt 2 ] && fib_score=1
    echo "  Check 17 - Fill-in-blanks: ${fib_count} -> ${fib_score}/2 pts"
    ((total_score += fib_score))

    # Check 18: Assertion-Reason in Section 7 (2 pts)
    local ar_score=0
    echo "$sec7_text" | grep -qi "assertion" && echo "$sec7_text" | grep -qi "reason" && ar_score=2
    echo "  Check 18 - Assertion-Reason (Sec 7): $([ "$ar_score" -eq 2 ] && echo "FOUND" || echo "NOT FOUND") -> ${ar_score}/2 pts"
    ((total_score += ar_score))

    # Check 19: Inline answers in Section 7 (2 pts)
    local ia_score=0
    local ia_count=0
    if [ -n "$sec7_text" ]; then
        ia_count=$(echo "$sec7_text" | grep -c '\*\*A[0-9]*:' 2>/dev/null) || ia_count=0
    fi
    [ "$ia_count" -ge 10 ] && ia_score=2
    [ "$ia_count" -ge 5 ] && [ "$ia_score" -lt 2 ] && ia_score=1
    echo "  Check 19 - Inline answers (Sec 7): ${ia_count} found -> ${ia_score}/2 pts"
    ((total_score += ia_score))

    # Check 20: Case-based/Source-based in Section 7 (2 pts)
    local case_score=0
    echo "$sec7_text" | grep -qi "case.based\|source.based\|case study\|source.based passage" && case_score=2
    echo "  Check 20 - Case/Source (Sec 7): $([ "$case_score" -eq 2 ] && echo "FOUND" || echo "NOT FOUND") -> ${case_score}/2 pts"
    ((total_score += case_score))

    local q_subtotal=$((q_score + mcq_score + fib_score + ar_score + ia_score + case_score))
    echo -e "  Subtotal D: ${q_subtotal}/15 pts"
    echo ""

    # =============================================
    # FINAL SCORE
    # =============================================
    echo -e "${GREEN}============================================${NC}"
    echo -e "${GREEN}TOTAL SCORE: ${total_score}/65${NC}"
    echo -e "${GREEN}============================================${NC}"

    local grade="D"
    [ "$total_score" -ge 33 ] && grade="C"
    [ "$total_score" -ge 39 ] && grade="B"
    [ "$total_score" -ge 46 ] && grade="B+"
    [ "$total_score" -ge 52 ] && grade="A"
    [ "$total_score" -ge 59 ] && grade="A+"
    echo -e "  Grade: ${grade}"
    echo ""

    # Save machine-readable score to temp file
    echo "${subject}:${total_score}:${struct_score}:${wc_subtotal}:${fmt_subtotal}:${q_subtotal}:${total_wc}:${cc_pct}:${sections_found}:${q_count}:${mcq_count}:${fib_count}:${star_count}:${tri_count}:${think_count}:${hr_count}" > "$SCORES_DIR/${subject}.score"
}

# =============================================
# MAIN
# =============================================

if [ $# -eq 0 ]; then
    echo "Usage: $0 <file1.md> [file2.md ...]"
    echo "       $0 <dir1> <dir2>"
    exit 1
fi

# Directory comparison mode
if [ $# -eq 2 ] && [ -d "$1" ] && [ -d "$2" ]; then
    dir1="$1"
    dir2="$2"

    echo "============================================================"
    echo " CBSE Notes Quality Comparison: Automated Scoring"
    echo "============================================================"
    echo ""

    # Score iteration 1
    echo -e "${BLUE}--- Iteration 1: ${dir1} ---${NC}"
    echo ""
    for f in "$dir1"/*.md; do
        [ -f "$f" ] || continue
        score_file "$f"
        echo ""
        echo "------------------------------------------------------------"
        echo ""
    done

    # Move scores to iter1 subdir
    mkdir -p "$SCORES_DIR/iter1"
    mv "$SCORES_DIR"/*.score "$SCORES_DIR/iter1/" 2>/dev/null || true

    # Score iteration 2
    echo -e "${BLUE}--- Iteration 2: ${dir2} ---${NC}"
    echo ""
    for f in "$dir2"/*.md; do
        [ -f "$f" ] || continue
        score_file "$f"
        echo ""
        echo "------------------------------------------------------------"
        echo ""
    done

    # Move scores to iter2 subdir
    mkdir -p "$SCORES_DIR/iter2"
    mv "$SCORES_DIR"/*.score "$SCORES_DIR/iter2/" 2>/dev/null || true

    # =============================================
    # COMPARISON SUMMARY
    # =============================================
    echo ""
    echo "============================================================"
    echo " COMPARISON SUMMARY"
    echo "============================================================"
    echo ""
    printf "| %-20s | %7s | %7s | %7s | %-10s |\n" "Subject" "Iter-1" "Iter-2" "Delta" "Winner"
    printf "|----------------------|---------|---------|---------|------------|\n"

    overall1=0; overall2=0

    for subject in maths science english history geography economics civics; do
        s1_line="" s2_line=""
        [ -f "$SCORES_DIR/iter1/${subject}.score" ] && s1_line=$(cat "$SCORES_DIR/iter1/${subject}.score")
        [ -f "$SCORES_DIR/iter2/${subject}.score" ] && s2_line=$(cat "$SCORES_DIR/iter2/${subject}.score")

        s1_total=0 s2_total=0
        [ -n "$s1_line" ] && s1_total=$(echo "$s1_line" | cut -d: -f2)
        [ -n "$s2_line" ] && s2_total=$(echo "$s2_line" | cut -d: -f2)

        overall1=$((overall1 + s1_total))
        overall2=$((overall2 + s2_total))

        delta=$((s2_total - s1_total))
        winner="---"
        if [ "$s1_total" -gt 0 ] && [ "$s2_total" -gt 0 ]; then
            if [ "$delta" -gt 5 ]; then winner="Iter-2 WIN"
            elif [ "$delta" -lt -5 ]; then winner="Iter-1 WIN"
            else winner="TIE"; fi
        elif [ "$s2_total" -gt 0 ] && [ "$s1_total" -eq 0 ]; then winner="Iter-2 NEW"
        elif [ "$s1_total" -gt 0 ] && [ "$s2_total" -eq 0 ]; then winner="Iter-1 NEW"
        fi

        delta_str="+${delta}"
        [ "$delta" -lt 0 ] && delta_str="${delta}"
        [ "$delta" -eq 0 ] && delta_str="  0"

        printf "| %-20s | %5s/65 | %5s/65 | %7s | %-10s |\n" \
            "$subject" "$s1_total" "$s2_total" "$delta_str" "$winner"
    done

    echo ""
    total_delta=$((overall2 - overall1))
    total_delta_str="+${total_delta}"
    [ "$total_delta" -lt 0 ] && total_delta_str="${total_delta}"
    printf "| %-20s | %5s    | %5s    | %7s | %-10s |\n" "OVERALL" "$overall1" "$overall2" "$total_delta_str" ""

    # Detailed breakdown
    echo ""
    echo "============================================================"
    echo " DETAILED BREAKDOWN (Iter-1 vs Iter-2)"
    echo "============================================================"
    echo ""

    for subject in maths science english history geography economics civics; do
        s1_line="" s2_line=""
        [ -f "$SCORES_DIR/iter1/${subject}.score" ] && s1_line=$(cat "$SCORES_DIR/iter1/${subject}.score")
        [ -f "$SCORES_DIR/iter2/${subject}.score" ] && s2_line=$(cat "$SCORES_DIR/iter2/${subject}.score")

        if [ -z "$s1_line" ] && [ -z "$s2_line" ]; then continue; fi

        echo -e "${BLUE}** ${subject} **${NC}"
        printf "| %-20s | %10s | %10s |\n" "Metric" "Iter-1" "Iter-2"
        printf "|----------------------|------------|------------|\n"

        # Extract fields
        s1_total=0 s1_struct=0 s1_wc=0 s1_fmt=0 s1_q=0 s1_twc=0 s1_ccp=0 s1_sec=0 s1_qc=0 s1_mcq=0 s1_fib=0 s1_star=0 s1_tri=0 s1_think=0 s1_hr=0
        s2_total=0 s2_struct=0 s2_wc=0 s2_fmt=0 s2_q=0 s2_twc=0 s2_ccp=0 s2_sec=0 s2_qc=0 s2_mcq=0 s2_fib=0 s2_star=0 s2_tri=0 s2_think=0 s2_hr=0

        if [ -n "$s1_line" ]; then
            s1_total=$(echo "$s1_line" | cut -d: -f2)
            s1_struct=$(echo "$s1_line" | cut -d: -f3)
            s1_wc=$(echo "$s1_line" | cut -d: -f4)
            s1_fmt=$(echo "$s1_line" | cut -d: -f5)
            s1_q=$(echo "$s1_line" | cut -d: -f6)
            s1_twc=$(echo "$s1_line" | cut -d: -f7)
            s1_ccp=$(echo "$s1_line" | cut -d: -f8)
            s1_sec=$(echo "$s1_line" | cut -d: -f9)
            s1_qc=$(echo "$s1_line" | cut -d: -f10)
            s1_mcq=$(echo "$s1_line" | cut -d: -f11)
            s1_fib=$(echo "$s1_line" | cut -d: -f12)
            s1_star=$(echo "$s1_line" | cut -d: -f13)
            s1_tri=$(echo "$s1_line" | cut -d: -f14)
            s1_think=$(echo "$s1_line" | cut -d: -f15)
            s1_hr=$(echo "$s1_line" | cut -d: -f16)
        fi

        if [ -n "$s2_line" ]; then
            s2_total=$(echo "$s2_line" | cut -d: -f2)
            s2_struct=$(echo "$s2_line" | cut -d: -f3)
            s2_wc=$(echo "$s2_line" | cut -d: -f4)
            s2_fmt=$(echo "$s2_line" | cut -d: -f5)
            s2_q=$(echo "$s2_line" | cut -d: -f6)
            s2_twc=$(echo "$s2_line" | cut -d: -f7)
            s2_ccp=$(echo "$s2_line" | cut -d: -f8)
            s2_sec=$(echo "$s2_line" | cut -d: -f9)
            s2_qc=$(echo "$s2_line" | cut -d: -f10)
            s2_mcq=$(echo "$s2_line" | cut -d: -f11)
            s2_fib=$(echo "$s2_line" | cut -d: -f12)
            s2_star=$(echo "$s2_line" | cut -d: -f13)
            s2_tri=$(echo "$s2_line" | cut -d: -f14)
            s2_think=$(echo "$s2_line" | cut -d: -f15)
            s2_hr=$(echo "$s2_line" | cut -d: -f16)
        fi

        printf "| %-20s | %5s/25   | %5s/25   |\n" "A. Structure" "$s1_struct" "$s2_struct"
        printf "| %-20s | %5s/10   | %5s/10   |\n" "B. Word Count" "$s1_wc" "$s2_wc"
        printf "| %-20s | %5s/15   | %5s/15   |\n" "C. Formatting" "$s1_fmt" "$s2_fmt"
        printf "| %-20s | %5s/15   | %5s/15   |\n" "D. Questions" "$s1_q" "$s2_q"
        printf "| %-20s | %10s | %10s |\n" "Total Score" "${s1_total}/65" "${s2_total}/65"
        echo ""
        printf "| %-20s | %10s | %10s |\n" "Total Words" "$s1_twc" "$s2_twc"
        printf "| %-20s | %9s%% | %9s%% |\n" "Core Content %" "$s1_ccp" "$s2_ccp"
        printf "| %-20s | %10s | %10s |\n" "Sections (of 7)" "$s1_sec" "$s2_sec"
        printf "| %-20s | %10s | %10s |\n" "Total Questions" "$s1_qc" "$s2_qc"
        printf "| %-20s | %10s | %10s |\n" "MCQs" "$s1_mcq" "$s2_mcq"
        printf "| %-20s | %10s | %10s |\n" "Fill-in-Blanks" "$s1_fib" "$s2_fib"
        printf "| %-20s | %10s | %10s |\n" "Stars (frequently tested)" "$s1_star" "$s2_star"
        printf "| %-20s | %10s | %10s |\n" "Triangles (important)" "$s1_tri" "$s2_tri"
        printf "| %-20s | %10s | %10s |\n" "Think About It" "$s1_think" "$s2_think"
        printf "| %-20s | %10s | %10s |\n" "Horizontal Rules" "$s1_hr" "$s2_hr"
        echo ""
    done

else
    # Single file mode
    for f in "$@"; do
        if [ -f "$f" ]; then
            score_file "$f"
            echo "------------------------------------------------------------"
            echo ""
        else
            echo "File not found: $f" >&2
        fi
    done
fi
