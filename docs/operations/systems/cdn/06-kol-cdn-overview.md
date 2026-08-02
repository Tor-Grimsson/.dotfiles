---
title: kol-cdn-overview skill
type: reference
status: active
updated: 2026-07-05
description: The orientation-only skill for the CDN — why it exists alongside the action skills, what it covers, and where its content is sourced from.
aliases:
  - kol-cdn-overview
tags:
  - project/dotfiles
  - domain/cloud
  - domain/ai/llm
related:
  - "[[INDEX|r2b2 index]]"
  - "[[01-b2|B2 buckets]]"
  - "[[03-r2|R2 bucket]]"
  - "[[kol-cdn-overview]]"
---

# kol-cdn-overview skill

`kol-bucket-b2` and `kol-bucket-r2` both trigger on **action** language (ls/tree/upload/sync/rm). A plain orientation question — "where's X stored", "what's the CDN layout", "which bucket holds Y" — doesn't match that framing, and the only place the answer lived was this folder's `INDEX.md`, which nothing surfaces unless the reader already knows to look here.

`kol-cdn-overview` (`claude/skills/kol-cdn-overview/SKILL.md`) closes that gap: a third, read-only skill that answers the orientation question directly — two providers, three buckets, what each holds, who consumes it, where the live tree snapshots are — without running anything. It sources its facts from [[01-b2|01-b2]] and [[03-r2|03-r2]] rather than duplicating them; when those docs change, update the skill to match.

## Why a separate skill, not just pointing people at `INDEX.md`

A doc only surfaces if someone already knows the path. A skill's `description` is matched against the question itself, so "where are the art prints stored" now has something to latch onto without the asker needing to know `18-cdn-r2b2/` exists.

## Related

- [[kol-bucket-b2]] / [[kol-bucket-r2]] — the action skills this one deliberately doesn't duplicate
- [[01-b2|B2 buckets]] / [[03-r2|R2 bucket]] — the source-of-truth docs the skill summarizes
