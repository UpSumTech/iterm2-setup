#!/usr/bin/env bash

plist="com.googlecode.iterm2.plist"
iTermPlist="$HOME/Library/Preferences/$plist"

err() {
  echo "Error : $@" >/dev/stderr
  exit 1
}

validate() {
  [[ -f "$iTermPlist" ]] || err "Iterm is not installed"
  [[ "$TERM_PROGRAM" != "iTerm.app" ]] || err "Cant setup iterm from within iterm"
  [[ -z "$(ps -ef | grep -U 'iTerm\.app')" ]] || err "iTerm is currently running. Please close it first."
}

fetchPreferences() {
  curl -s -S \
    -H "Cache-Control: no-cache" \
    -L "https://github.com/sumanmukherjee03/iterm2-setup/raw/master/$plist" | plutil -convert binary1 -o "$iTermPlist" -
}

verify() {
  defaults read com.googlecode.iterm2
}

main() {
  validate
  fetchPreferences
  verify
}

[[ "$BASH_SOURCE" == "$0" ]] && main "$@"
