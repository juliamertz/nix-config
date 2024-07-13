; extends

; Injects SQL highlighting into `sqlx:query` macro invocations
(field_expression(_
  (scoped_identifier 
    path: (identifier) @path (#eq? @path "sqlx")
    name: (identifier) @name (#match? @name "query.*")
  )
  (_(_
    (string_content) @injection.content)
    (#set! injection.language "sql")
  ))
)
