#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_DIR="$SCRIPT_DIR/../apps/mobile"
ENV_FILE="$APP_DIR/.env.json"

if [ ! -f "$ENV_FILE" ]; then
  echo "Error: .env.json not found at apps/mobile/.env.json"
  echo ""
  echo "Create it with:"
  echo '{'
  echo '  "SUPABASE_URL": "https://<project-ref>.supabase.co",'
  echo '  "SUPABASE_ANON_KEY": "<anon_key>",'
  echo '  "SUPABASE_EDGE_BASE_URL": "https://<project-ref>.supabase.co/functions/v1",'
  echo '  "FIREBASE_API_KEY_ANDROID": "<android_api_key>",'
  echo '  "FIREBASE_APP_ID_ANDROID": "<android_app_id>",'
  echo '  "FIREBASE_API_KEY_IOS": "<ios_api_key>",'
  echo '  "FIREBASE_APP_ID_IOS": "<ios_app_id>",'
  echo '  "FIREBASE_MESSAGING_SENDER_ID": "<sender_id>",'
  echo '  "FIREBASE_PROJECT_ID": "<project_id>",'
  echo '  "FIREBASE_STORAGE_BUCKET": "<project_id>.firebasestorage.app",'
  echo '  "FIREBASE_IOS_BUNDLE_ID": "com.spacetime.mobile"'
  echo '}'
  echo ""
  echo "Firebase values can be found by running: flutterfire configure"
  exit 1
fi

cd "$APP_DIR"
flutter run --dart-define-from-file=.env.json "$@"
