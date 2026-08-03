; extends

; Conceal ATX heading markers (#, ##, ... ######). The base nvim-treesitter
; query colors the whole heading via @markup.heading.N but never conceals the
; marker itself — emphasis (**) and code-span backticks already conceal in
; markdown_inline/highlights.scm, this brings headings in line with that:
; the color already shows the level, the hashes are redundant once styled.

(atx_heading
  (atx_h1_marker) @conceal
  (#set! conceal ""))

(atx_heading
  (atx_h2_marker) @conceal
  (#set! conceal ""))

(atx_heading
  (atx_h3_marker) @conceal
  (#set! conceal ""))

(atx_heading
  (atx_h4_marker) @conceal
  (#set! conceal ""))

(atx_heading
  (atx_h5_marker) @conceal
  (#set! conceal ""))

(atx_heading
  (atx_h6_marker) @conceal
  (#set! conceal ""))
