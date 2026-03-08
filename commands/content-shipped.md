---
name: content-shipped
description: Log a published piece of content to content/log.md. Use after publishing a blog post, LinkedIn post, newsletter, podcast episode, or any public content.
allowed-tools: Read, Edit
---

# /content-shipped — Log Published Content

## Instructions

### 1. Gather details

Ask the user for (or infer from context):
- **Title** of the piece
- **Type** (blog post, LinkedIn post, newsletter, podcast, video, talk)
- **Platform** (where it was published)
- **URL** (link to the published piece)
- **Topic** (1-line summary)

### 2. Add entry to content/log.md

Add a new entry at the top of the file (after the header), using this format:

```markdown
## [DATE] — [Title]

- **Type:** [type]
- **Platform:** [platform]
- **URL:** [url]
- **Topic:** [summary]
- **Performance:** [to be updated]
```

### 3. Confirm

Tell the user the entry was logged and remind them to update performance metrics later if relevant.
