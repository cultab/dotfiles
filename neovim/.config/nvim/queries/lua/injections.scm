;; extends

; ; highlight vim.cmd
; ((function_call
;   name: (_) @_vimcmd_identifier
;   arguments: (arguments (string content: _ @none @nospell)))
;   (#any-of? @_vimcmd_identifier "vim.cmd" "vim.api.nvim_command" "vim.api.nvim_exec"))
;
; ; highlight map "<leader>s" { "vimscript here" }
; ((function_call
;   name: (function_call name: (identifier) @id)
;   arguments: (arguments (table_constructor . (field value: (string content: _ @none @nospell @vim)))))
; (#eq? @id "map")
; )
