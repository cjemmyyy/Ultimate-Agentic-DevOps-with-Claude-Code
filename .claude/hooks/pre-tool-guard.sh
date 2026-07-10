#!/bin/bash
# PreToolUse hook — blocks dangerous Bash commands before execution

INPUT=$(cat)
CMD=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if echo "$CMD" | grep -qE "terraform destroy|terraform apply.*-auto-approve|aws s3 rm|aws s3 rb"; then
  echo "Destructive command detected. Use /tf-destroy or /tf-apply commands for safety." >&2
  exit 2
fi
exit 0