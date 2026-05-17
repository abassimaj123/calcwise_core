#!/usr/bin/env bash
# activate_ios.sh — copy iOS templates into a portfolio app.
#
# Usage:
#   bash activate_ios.sh <AppName>           # dry-run (default) — shows what would change
#   bash activate_ios.sh <AppName> --apply   # actually write files
#
# This script ONLY touches files under <AppName>/ios/Runner/.
# It never modifies android/, lib/, pubspec.yaml, or any Dart code.
#
# Repo root is assumed to be D:/mob (parent of the app folder). Override with PORTFOLIO_ROOT env var.

set -euo pipefail

TEMPLATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PORTFOLIO_ROOT="${PORTFOLIO_ROOT:-$(cd "$TEMPLATE_DIR/../../.." && pwd)}"

APP_NAME="${1:-}"
MODE="${2:-dry-run}"

if [[ -z "$APP_NAME" ]]; then
  echo "Usage: bash activate_ios.sh <AppName> [--apply]"
  echo
  echo "Available apps:"
  ls -1 "$PORTFOLIO_ROOT" | grep -v '^_' | grep -v '^\.' || true
  exit 1
fi

APP_DIR="$PORTFOLIO_ROOT/$APP_NAME"
IOS_DIR="$APP_DIR/ios/Runner"

if [[ ! -d "$APP_DIR" ]]; then
  echo "ERROR: app directory not found: $APP_DIR"
  exit 1
fi

if [[ ! -d "$APP_DIR/ios" ]]; then
  echo "ERROR: $APP_DIR has no ios/ folder."
  echo "       Run 'flutter create --platforms=ios .' inside $APP_DIR first,"
  echo "       then re-run this script."
  exit 1
fi

# Derive bundle ID heuristically — read from existing project.pbxproj if possible
BUNDLE_ID="$(grep -m1 'PRODUCT_BUNDLE_IDENTIFIER' "$APP_DIR/ios/Runner.xcodeproj/project.pbxproj" 2>/dev/null \
  | sed 's/.*= //; s/;//' | tr -d ' "' || true)"
BUNDLE_ID="${BUNDLE_ID:-com.example.${APP_NAME,,}}"

# AdMob App ID — leave as placeholder, user must fill in
ADMOB_APP_ID="ca-app-pub-3940256099942544~1458002511"  # iOS TEST app ID

echo "═══════════════════════════════════════════════════════════════════"
echo "  iOS activation for: $APP_NAME"
echo "  Mode: $MODE"
echo "  Target: $IOS_DIR"
echo "  Bundle ID (detected): $BUNDLE_ID"
echo "  AdMob App ID (placeholder): $ADMOB_APP_ID"
echo "═══════════════════════════════════════════════════════════════════"
echo

substitute() {
  sed -e "s|{{APP_NAME}}|$APP_NAME|g" \
      -e "s|{{BUNDLE_ID}}|$BUNDLE_ID|g" \
      -e "s|{{ADMOB_APP_ID}}|$ADMOB_APP_ID|g" \
      "$1"
}

copy_file() {
  local src="$1"
  local dst="$2"
  if [[ "$MODE" == "--apply" ]]; then
    substitute "$src" > "$dst"
    echo "  [WRITE] $dst"
  else
    echo "  [DRY]   would write $dst"
  fi
}

# ── File operations ─────────────────────────────────────────────────────
echo "Files to be created/updated:"
echo
copy_file "$TEMPLATE_DIR/AppDelegate.swift.template"   "$IOS_DIR/AppDelegate.swift"
copy_file "$TEMPLATE_DIR/PrivacyInfo.xcprivacy.template" "$IOS_DIR/PrivacyInfo.xcprivacy"

# SKAdNetworkItems.plist is reference-only — user merges into Info.plist
if [[ "$MODE" == "--apply" ]]; then
  cp "$TEMPLATE_DIR/SKAdNetworkItems.plist" "$IOS_DIR/SKAdNetworkItems.plist"
  echo "  [WRITE] $IOS_DIR/SKAdNetworkItems.plist (reference — merge into Info.plist manually)"
else
  echo "  [DRY]   would write $IOS_DIR/SKAdNetworkItems.plist"
fi

# Info.plist additions — printed as instructions, NOT auto-merged (too risky)
echo
echo "Info.plist — manual merge required:"
if [[ -f "$IOS_DIR/Info.plist" ]]; then
  echo "  Open $IOS_DIR/Info.plist and merge keys from:"
  echo "    $TEMPLATE_DIR/Info.plist.additions.xml"
  echo "  Then copy the <array> from SKAdNetworkItems.plist under <key>SKAdNetworkItems</key>."
else
  echo "  WARNING: $IOS_DIR/Info.plist does not exist. Run 'flutter create --platforms=ios .' first."
fi

echo
echo "═══════════════════════════════════════════════════════════════════"
echo "  TODO checklist (manual, post-script):"
echo "═══════════════════════════════════════════════════════════════════"
cat <<'EOF'
  [ ] Create iOS app in Firebase console for the same Firebase project
  [ ] Download GoogleService-Info.plist; drag into Xcode under Runner/
      (do NOT commit — it contains API keys; .gitignore should already exclude it)
  [ ] Create iOS AdMob app + ad units in AdMob console
  [ ] Replace placeholder ADMOB_APP_ID in Info.plist with the real one
  [ ] Update lib/.../ad_config.dart iOS unit IDs (banneriOS, interstitialiOS, rewardediOS)
  [ ] Run: cd ios && pod install
  [ ] Open ios/Runner.xcworkspace, add PrivacyInfo.xcprivacy to the Runner target
  [ ] Set iOS deployment target to 13.0 (in Xcode + Podfile)
  [ ] Update Info.plist: CFBundleDisplayName, marketing version, build number
  [ ] Configure Apple Developer team in Xcode signing settings
  [ ] Test on a real device — AdMob will not show personalized ads on simulator
EOF

echo
if [[ "$MODE" != "--apply" ]]; then
  echo "DRY-RUN complete. Re-run with --apply to write files."
else
  echo "Done. Files written. Next: follow TODO checklist above."
fi
