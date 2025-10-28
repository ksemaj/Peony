#!/bin/bash

# Script to verify Prompts.json is in the app bundle

echo "🔍 Searching for Peony.app..."

# Find the most recent build
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "Peony.app" -type d 2>/dev/null | head -1)

if [ -z "$APP_PATH" ]; then
    echo "❌ Peony.app not found. Build the app first (Cmd+B)."
    exit 1
fi

echo "✅ Found app at: $APP_PATH"
echo ""

# Check if Prompts.json exists in bundle
if [ -f "$APP_PATH/Prompts.json" ]; then
    echo "✅ SUCCESS! Prompts.json is in the app bundle"
    echo ""
    echo "File details:"
    ls -lh "$APP_PATH/Prompts.json"
    echo ""
    echo "First few lines:"
    head -5 "$APP_PATH/Prompts.json"
else
    echo "❌ FAILED! Prompts.json is NOT in the app bundle"
    echo ""
    echo "Files in bundle:"
    ls -la "$APP_PATH" | head -20
fi


