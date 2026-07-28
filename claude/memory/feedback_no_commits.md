---
name: Never commit on behalf of user
description: User does not want Claude to create git commits for them
type: feedback
---

Never offer to commit or create commits on behalf of the user.

**Why:** User explicitly said "never" when asked if they want help committing.

**How to apply:** Do not offer to commit, and do not use the /commit skill. Let the user handle all git commits themselves.
