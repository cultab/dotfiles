; extends

(
  (
    paragraph (inline) @latex (#match? @latex "\\\\begin\\{.*\\}(\\n|.|\\r|\\r\\n)*\\\\end\\{.*\\}")
  ) @injection.content
  (#set! injection.language "latex")
)
