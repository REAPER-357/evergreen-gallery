#!/usr/bin/env bash
# Run on your computer (needs internet + Node). Builds the offline app from www/index.src.html,
# updates the Android plugin files, and syncs to Android. Safe to re-run any time.
set -e
cd "$(dirname "$0")"
[ -f www/index.src.html ] || { echo "www/index.src.html is missing"; exit 1; }
npm i --no-save tailwindcss@3.4.17 @fortawesome/fontawesome-free@6.4.0
npx tailwindcss -c tailwind.config.js -i input.css -o www/tailwind.css --minify
mkdir -p www/fa/css www/fa/webfonts
cp node_modules/@fortawesome/fontawesome-free/css/all.min.css www/fa/css/
cp node_modules/@fortawesome/fontawesome-free/webfonts/* www/fa/webfonts/
python3 - <<'PY'
s = open('www/index.src.html', encoding='utf-8').read()
s = s.replace('<script src="https://cdn.tailwindcss.com"></script>\n', '<link rel="stylesheet" href="tailwind.css">\n')
s = s.replace("<script>tailwind.config = { darkMode: 'class' }</script>\n", '')
s = s.replace('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css', 'fa/css/all.min.css')
open('www/index.html', 'w', encoding='utf-8').write(s)
PY
# Android: copy the permission plugin and MainActivity into the project (keeps your package name)
MA=$(find android/app/src/main/java -name MainActivity.java 2>/dev/null | head -1 || true)
if [ -n "$MA" ]; then
  D=$(dirname "$MA"); PKG=$(grep -m1 '^package ' "$MA" | sed 's/package \(.*\);/\1/')
  for f in GalleryToolsPlugin MainActivity; do sed "s/^package .*;/package $PKG;/" "android-plugin/$f.java" > "$D/$f.java"; done
  echo "Android plugin files updated in $D"
fi
[ -d android ] && npx cap sync android
echo "Done. Edit www/index.src.html, then run this script again."
