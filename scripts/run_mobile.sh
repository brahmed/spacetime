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
  echo '  "SUPABASE_EDGE_BASE_URL": "https://<project-ref>.supabase.co/functions/v1"'
  echo '}'
  exit 1
fi

cd "$APP_DIR"
flutter run --dart-define-from-file=.env.json "$@"
