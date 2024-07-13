; extends

(call_expression
  function: (selector_expression
      operand: (identifier) @operand (#match? @operand "(db|tx|stmt)")
      field: (field_identifier) @field (#match? @field "(Exec|Prepare|Query)")
  )
  arguments: (argument_list
      (raw_string_literal) @injection.content
      (#offset! @injection.content 0 1 0 -1)
      (#set! injection.language "sql")
  )
) 
