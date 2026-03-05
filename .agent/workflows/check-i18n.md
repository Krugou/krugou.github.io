---
description: Check for missing translation keys across all locales
---

// turbo

1. Run the translation check script using ts-node:

```bash
npx ts-node scripts/check-translations.ts
```

This command now automatically inserts any missing keys into each locale’s `translation.json` (english entries default to the key itself and other languages mirror the English text or use an empty placeholder).

1. When the script exits with a non‑zero status it means there were missing keys; inspect the console output to see which files were modified and what keys were added.

1. **Important:** open the updated `src/locales/<locale>/translation.json` files, review the auto‑added entries, and provide proper translated values before committing.

> The workflow helps keep all language files in sync and reduces manual maintenance.
