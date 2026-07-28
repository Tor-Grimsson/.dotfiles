---
name: no-change-means-full-audit
description: "\"I don't want any change to happen\" requires a full audit of every active setting before acting, not a spot-check of the categories that seemed relevant"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 266ef8cf-c005-4468-a753-d554c4784fdf
---

When the user sets a hard boundary like "I don't want any change to happen, don't want a random variable as a pet bug" before authorizing a live config-loading switch (e.g. iTerm's `LoadPrefsFromCustomFolder`), a diff check that only inspects the categories that seem likely to differ (color presets, one clipboard key) is not sufficient sign-off — it's a shallow check presented as thorough.

**Why:** Flipped iTerm2 to load a repo plist last refreshed 11 days earlier, having only diffed which top-level `<key>` names appeared in the presets section plus the one clipboard key I cared about. Didn't check whether the **active** Default profile (font, colors, keybindings) had drifted in those 11 days. It had. Visual breakage followed immediately, directly contradicting the explicit "nothing should change" boundary set one message earlier — a real, costly incident, not a near-miss.

**How to apply:** Before flipping any live setting that changes what config an app reads from (custom-folder loading, a symlink retarget, a profile switch), diff the **specific active/effective configuration** end-to-end — not just the keys that seem topically related to the task at hand — or don't do it live at all. If a full audit isn't cheap, say so and let the user decide whether to accept the risk, rather than asserting "clean" from a partial check. Related: [[feedback_dont_hedge_known_facts]] (don't assert certainty you haven't earned).
