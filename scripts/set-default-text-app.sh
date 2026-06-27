#!/usr/bin/env bash

set -euo pipefail

bundle_id="${NEOVIDE_BUNDLE_ID:-com.neovide.neovide}"
app_path="${NEOVIDE_APP_PATH:-/Applications/Neovide.app}"
plist_path="$HOME/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist"
lsregister="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"

if [[ ! -d "$app_path" ]]; then
  found_app="$(find /Applications "$HOME/Applications" /opt/homebrew/Caskroom -maxdepth 4 -name Neovide.app -print -quit 2>/dev/null || true)"
  if [[ -n "$found_app" ]]; then
    app_path="$found_app"
  else
    echo "Neovide.app was not found. Install it with: brew install --cask neovide" >&2
    exit 1
  fi
fi

actual_bundle_id="$(/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "$app_path/Contents/Info.plist")"
if [[ "$actual_bundle_id" != "$bundle_id" ]]; then
  echo "Expected bundle id $bundle_id, found $actual_bundle_id at $app_path" >&2
  exit 1
fi

mkdir -p "$(dirname "$plist_path")"

if [[ -x "$lsregister" ]]; then
  "$lsregister" -f "$app_path" >/dev/null 2>&1 || true
fi

/usr/bin/python3 - "$plist_path" "$bundle_id" <<'PY'
import os
import plistlib
import sys
import time

plist_path, bundle_id = sys.argv[1], sys.argv[2]

content_types = [
    "public.plain-text",
    "public.text",
    "public.source-code",
    "net.daringfireball.markdown",
    "public.json",
    "public.xml",
    "public.shell-script",
    "public.python-script",
    "public.ruby-script",
    "public.perl-script",
    "public.php-script",
    "public.c-source",
    "public.c-plus-plus-source",
    "public.c-header",
    "public.objective-c-source",
    "public.objective-c-plus-plus-source",
]

extensions = [
    "txt",
    "text",
    "utf8",
    "md",
    "markdown",
    "mdown",
    "markd",
    "log",
    "conf",
    "config",
    "cfg",
    "ini",
    "toml",
    "yaml",
    "yml",
    "json",
    "jsonc",
    "json5",
    "vim",
    "lua",
    "fnl",
    "clj",
    "cljs",
    "cljc",
    "edn",
    "sh",
    "zsh",
    "bash",
    "py",
    "rb",
    "js",
    "ts",
    "tsx",
    "go",
    "rs",
    "c",
    "h",
    "cc",
    "cpp",
    "cxx",
    "hpp",
    "sql",
]

if os.path.exists(plist_path):
    with open(plist_path, "rb") as plist_file:
        data = plistlib.load(plist_file)
else:
    data = {}

handlers = data.get("LSHandlers", [])
if not isinstance(handlers, list):
    handlers = []

target_keys = {("type", content_type) for content_type in content_types}
target_keys.update(
    ("tag", "public.filename-extension", extension) for extension in extensions
)

def handler_key(handler):
    if "LSHandlerContentType" in handler:
        return ("type", handler["LSHandlerContentType"])
    if "LSHandlerContentTag" in handler and "LSHandlerContentTagClass" in handler:
        return (
            "tag",
            handler["LSHandlerContentTagClass"],
            handler["LSHandlerContentTag"],
        )
    return None

handlers = [
    handler for handler in handlers
    if handler_key(handler) not in target_keys
]

modification_date = int(time.time() - 978307200)

for content_type in content_types:
    handlers.append({
        "LSHandlerContentType": content_type,
        "LSHandlerModificationDate": modification_date,
        "LSHandlerPreferredVersions": {"LSHandlerRoleAll": "-"},
        "LSHandlerRoleAll": bundle_id,
    })

for extension in extensions:
    handlers.append({
        "LSHandlerContentTag": extension,
        "LSHandlerContentTagClass": "public.filename-extension",
        "LSHandlerModificationDate": modification_date,
        "LSHandlerPreferredVersions": {"LSHandlerRoleAll": "-"},
        "LSHandlerRoleAll": bundle_id,
    })

data["LSHandlers"] = handlers

tmp_path = f"{plist_path}.tmp"
with open(tmp_path, "wb") as plist_file:
    plistlib.dump(data, plist_file, fmt=plistlib.FMT_BINARY, sort_keys=False)
os.replace(tmp_path, plist_path)

print(
    f"Configured {bundle_id} as default for "
    f"{len(content_types)} text UTIs and {len(extensions)} filename extensions."
)
PY

/usr/bin/killall cfprefsd >/dev/null 2>&1 || true

echo "Done. If Finder still shows the previous app, log out and back in."
