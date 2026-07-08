---
title: "DISTORTION EFFECT w Three.js #webdesign #webdevelopment #3d"
source: https://www.tiktok.com/@malik.code/video/7637871728068185366?lang=en
platform: TikTok
uploader: "malik.code"
published: 2026-05-09
duration: 28
transcribed: 2026-06-10
model: ggml-base
tags:
  - transcript
---

# DISTORTION EFFECT w Three.js #webdesign #webdevelopment #3d

## Transcript

how to create a text distortion effect with 3JS. Text gets drawn onto a hidden canvas. That canvas becomes a flat surface, your shader can manipulate. The effect we want doesn't react instantly to your cursor. It lags and fades out when you stop moving your cursor. A shader program runs on every pixel near a cursor. And instead of reading from the right pixel, it reads from a slightly wrong one. And that's the distortion. On top of that, the red, green, and blue color channels get shifted to a slightly different position. That's the color bleeding you see at the edges.
