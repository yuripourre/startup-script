# Install Claude Code
curl -fsSL https://claude.ai/install.sh | bash

# Add alias for Claude Code
echo 'alias yolo="claude --dangerously-skip-permissions"' >>~/.bashrc
source ~/.bashrc

# Update ~/.claude/settings.json with Stop hook (sound on stop).
SETTINGS_FILE="$HOME/.claude/settings.json"
NEW_STOP_ENTRY='{"hooks":[{"type":"command","command":"pw-play /usr/share/sounds/speech-dispatcher/glass-water-1.wav"}]}'
TARGET_CMD="pw-play /usr/share/sounds/speech-dispatcher/glass-water-1.wav"

mkdir -p "$(dirname "$SETTINGS_FILE")"
if [[ -f "$SETTINGS_FILE" ]]; then
  current=$(cat "$SETTINGS_FILE")
else
  current='{}'
fi

updated=$(echo "$current" | jq --argjson new "$NEW_STOP_ENTRY" --arg cmd "$TARGET_CMD" '
  .hooks = ((.hooks // {}) | .Stop = (
    (.Stop // []) | if any(.[]; (.hooks[]? | .command == $cmd)) then . else . + [$new] end
  ))
')
echo "$updated" > "$SETTINGS_FILE"
echo "Updated $SETTINGS_FILE with Stop hook."
