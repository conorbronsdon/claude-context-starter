# Notion MCP Setup

Connect Claude Code to your Notion workspace using the official [notion-mcp-server](https://github.com/makenotion/notion-mcp-server).

## 1. Create a Notion Integration

1. Go to [notion.so/my-integrations](https://www.notion.so/my-integrations)
2. Click **New integration**
3. Name it (e.g., "Claude Code")
4. Select your workspace
5. Copy the **Internal Integration Secret** (starts with `ntn_`)

## 2. Share Pages with the Integration

In Notion, open each page/database you want Claude to access:
1. Click **···** (top right) → **Connections** → **Connect to** → select your integration
2. This grants read/write access to that page and its children

## 3. Install the MCP Server

```bash
npm install -g @notionhq/notion-mcp-server
```

## 4. Configure Claude Code

Add to `.claude/settings.local.json`:

```json
{
  "mcpServers": {
    "notion": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@notionhq/notion-mcp-server"],
      "env": {
        "NOTION_API_KEY": "ntn_YOUR_KEY_HERE"
      }
    }
  }
}
```

> **Security:** Don't commit your API key. Add `.claude/settings.local.json` to `.gitignore` or use an environment variable.

## 5. Verify

Start a Claude Code session and check that Notion tools are available:
- `notion_search` — search pages and databases
- `notion_retrieve_page` — read a page
- `notion_query_database` — query a database
- `notion_create_page` — create pages
- `notion_update_page` — update page properties

## Common Uses

- **Meeting notes:** Search and read meeting notes from Notion databases
- **Decision docs:** Read and reference internal decision documents
- **Task tracking:** Query project databases for status updates
- **Knowledge base:** Search internal docs for context during work sessions
