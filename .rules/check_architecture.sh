#!/bin/bash

# Peony Architecture Compliance Checker
# Enforces rules defined in .rules/ARCHITECTURE_RULES.md

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Go up one level to project root
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"
PROJECT_DIR="$PROJECT_ROOT/Peony"
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "🏛️  Peony Architecture Compliance Check"
echo "========================================"
echo ""

VIOLATIONS=0
WARNINGS=0

# Rule 1: Check file sizes (guideline 400-500 lines)
echo "📏 Checking file sizes..."
while IFS= read -r file; do
    lines=$(wc -l < "$file")
    if [ "$lines" -gt 800 ]; then
        echo -e "${RED}❌ VIOLATION${NC}: $file has $lines lines (getting excessive - is it hard to navigate?)"
        ((VIOLATIONS++))
    elif [ "$lines" -gt 500 ]; then
        echo -e "${YELLOW}⚠️  INFO${NC}: $file has $lines lines (getting large - is it still clear?)"
        # Not counting as warning, just info
    fi
done < <(find "$PROJECT_DIR" -name "*.swift" -type f)

# Rule 2: Check for backup files
echo ""
echo "🗑️  Checking for backup files..."
if find "$PROJECT_DIR" -name "*.bak" -o -name "*_OLD.swift" -o -name "*_NEW.swift" | grep -q .; then
    echo -e "${RED}❌ VIOLATION${NC}: Found backup files in repository"
    find "$PROJECT_DIR" \( -name "*.bak" -o -name "*_OLD.swift" -o -name "*_NEW.swift" \) -exec echo "  - {}" \;
    ((VIOLATIONS++))
else
    echo -e "${GREEN}✅ No backup files found${NC}"
fi

# Rule 3: Check for files in root (only PeonyApp.swift allowed)
echo ""
echo "📂 Checking root directory..."
root_swift_files=$(find "$PROJECT_DIR" -maxdepth 1 -name "*.swift" -type f ! -name "PeonyApp.swift" | wc -l)
if [ "$root_swift_files" -gt 0 ]; then
    echo -e "${RED}❌ VIOLATION${NC}: Found Swift files in root (only PeonyApp.swift allowed)"
    find "$PROJECT_DIR" -maxdepth 1 -name "*.swift" -type f ! -name "PeonyApp.swift" -exec echo "  - {}" \;
    ((VIOLATIONS++))
else
    echo -e "${GREEN}✅ Root directory clean (only PeonyApp.swift)${NC}"
fi

# Rule 4: Check for empty directories
echo ""
echo "📁 Checking for empty directories..."
if find "$PROJECT_DIR" -type d -empty | grep -q .; then
    echo -e "${YELLOW}⚠️  WARNING${NC}: Found empty directories"
    find "$PROJECT_DIR" -type d -empty -exec echo "  - {}" \;
    ((WARNINGS++))
else
    echo -e "${GREEN}✅ No empty directories${NC}"
fi

# Rule 5: Check directory structure
echo ""
echo "🏗️  Verifying directory structure..."
required_dirs=(
    "$PROJECT_DIR/Models"
    "$PROJECT_DIR/Utilities"
    "$PROJECT_DIR/Components"
    "$PROJECT_DIR/Views"
)

for dir in "${required_dirs[@]}"; do
    if [ ! -d "$dir" ]; then
        echo -e "${RED}❌ VIOLATION${NC}: Required directory missing: $dir"
        ((VIOLATIONS++))
    fi
done

# Summary
echo ""
echo "========================================"
echo "📊 Summary"
echo "========================================"
echo -e "Real Violations: ${RED}$VIOLATIONS${NC}"
echo -e "Warnings: ${YELLOW}$WARNINGS${NC}"
echo ""

if [ "$VIOLATIONS" -eq 0 ]; then
    echo -e "${GREEN}✅ Architecture compliance: PASSED${NC}"
    echo "🎉 Code is organized and in the right places."
    if [ "$WARNINGS" -gt 0 ]; then
        echo "💡 Some files are large but that's okay if they're clear."
    fi
    exit 0
else
    echo -e "${RED}❌ Architecture compliance: FAILED${NC}"
    echo "🚨 Fix violations (wrong directories, backups, etc)"
    echo ""
    echo "📖 Review .rules/ARCHITECTURE_RULES.md for guidance."
    exit 1
fi

