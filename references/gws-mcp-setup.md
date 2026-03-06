# Google Workspace CLI (gws) — MCP Setup Guide

**Last Updated:** [DATE — update when you verify against the current gws version]

## What this is

`gws` is a Rust CLI that dynamically generates commands from Google's Discovery Service at runtime. It covers Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and every other Workspace API — no manual updates needed when Google ships new endpoints.

The key unlock: `gws mcp` starts a Model Context Protocol server over stdio, making your entire Google Workspace agent-accessible from Claude Code.

**Status:** v0.3.4, pre-1.0, actively developed. Expect breaking changes. Not an officially supported Google product (despite living under the googleworkspace org). Single primary maintainer (Justin Poehnelt, Google DevRel).

**Repo:** https://github.com/googleworkspace/cli

## Install

```bash
npm install -g @googleworkspace/cli
# or build from source:
git clone https://github.com/googleworkspace/cli.git && cd cli && cargo install --path .
```

## Authenticate

```bash
# Interactive OAuth (opens browser, stores creds in OS keyring)
gws auth setup

# Or service account for headless/CI:
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/key.json
```

## Add MCP server to Claude Code

The `.mcp.json` in this repo is already configured. Claude Code picks it up automatically when you run it from this directory. No extra steps needed once gws is installed and authenticated.

If you want to customize which APIs are exposed, edit `.mcp.json`:

```json
{
  "mcpServers": {
    "google-workspace": {
      "command": "gws",
      "args": ["mcp", "-s", "drive,gmail,calendar,sheets", "-w"],
      "env": {}
    }
  }
}
```

**Service selection with `-s`:**
- `-s all` — every Workspace API (can be noisy)
- `-s drive,gmail,calendar,sheets` — recommended starting set
- `-w` — also expose workflow tools (weekly digest, meeting prep, standup report)

More services = more tools in context = more tokens. Tune to what you actually use.

## What you can do once connected

| What | How |
|------|-----|
| Search Gmail | `gmail_users_messages_list` with query params |
| Read/send email | `gmail_users_messages_get`, `gmail_users_messages_send` |
| List Drive files | `drive_files_list` with search query |
| Read/create Docs | `docs_documents_get`, `docs_documents_create` |
| Query/append Sheets | `sheets_spreadsheets_values_get`, `sheets_spreadsheets_values_append` |
| Calendar events | `calendar_events_list`, `calendar_events_insert` |
| Weekly digest | `workflow_weekly_digest` (with `-w` flag) |

## Safety rules

1. **Schema first:** If unsure about a payload, run `gws schema <resource>.<method>` before executing
2. **Field masks:** Always use `--fields` or `--params '{"fields": "id,name"}'` to limit response size — Workspace APIs return massive JSON
3. **Dry-run mutations:** Use `--dry-run` for any create/update/delete to validate before executing
4. **Never output secrets** (API keys, tokens) in file contents or commits

## Workflow ideas

- **Session start:** Pull your calendar for the week and unread email count automatically with `/start`
- **Project tracking:** Query a Google Sheet tracker to get live status on anything you manage
- **Content pipeline:** Maintain a Sheets-based log of what you've published, pitched, or shipped
- **Outreach:** Draft emails with Claude, send via Gmail MCP — no copy-paste
- **Weekly review:** Pull calendar + email activity to feed a summary or reflection
