" GuiTabline 1
" Guifont Iosevka Custom:h12
" Guifont Iosevka Nerd Font Mono:h12

if exists("g:nvui")
    NvuiCmdFontFamily FuraCode Nerd Font
    NvuiCmdFontSize 25.0
    NvuiScrollAnimationDuration 0.2
end

if exists('g:fvim_loaded')
    " good old 'set guifont' compatibility with HiDPI hints...
    if g:fvim_os == 'windows' || g:fvim_render_scale > 1.0
        set guifont=Iosevka:h18
    else
        "the above but double
        set guifont=Iosevka:h36
    endif

    " Ctrl-ScrollWheel for zooming in/out
    nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
    nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>
    augroup FVIM
        autocmd!
        autocmd BufWritePost ginit.vim nested source <afile> | lua vim.notify("Sourced!")
    augroup END
    " Toggle between normal and fullscreen
    " FVimToggleFullScreen

    " Cursor tweaks
    FVimCursorSmoothMove v:false
    FVimCursorSmoothBlink v:false

    " Background composition
    " 'none', 'transparent', 'blur' or 'acrylic'
    FVimBackgroundComposition 'none'
    " value between 0 and 1, default bg opacity.
    " FVimBackgroundOpacity 0.95
    " value between 0 and 1, non-default bg opacity.
    " FVimBackgroundAltOpacity 0.85
    " FVimBackgroundImage 'C:/foobar.png'   " background image
    " FVimBackgroundImageVAlign 'center'    " vertial position, 'top', 'center' or 'bottom'
    " FVimBackgroundImageHAlign 'center'    " horizontal position, 'left', 'center' or 'right'
    " FVimBackgroundImageStretch 'fill'     " 'none', 'fill', 'uniform', 'uniformfill'
    " FVimBackgroundImageOpacity 0.85       " value between 0 and 1, bg image opacity

    " Title bar tweaks
    " themed with colorscheme
    FVimCustomTitleBar v:true

    " Debug UI overlay
    FVimDrawFPS v:false

    " Font tweaks
    FVimFontAntialias v:true
    FVimFontAutohint v:true
    FVimFontHintLevel 'full'
    FVimFontLigature v:true
    " can be 'default', '14.0', '-1.0' etc.
    FVimFontLineHeight '+1.0'
    FVimFontSubpixel v:true
    " FVimFontNoBuiltinSymbols v:true " Disable built-in Nerd font symbols
    "
    " Try to snap the fonts to the pixels, reduces blur
    " in some situations (e.g. 100% DPI).
    FVimFontAutoSnap v:true

    " Font weight tuning, possible valuaes are 100..900
    " FVimFontNormalWeight 400
    " FVimFontBoldWeight 700
    "
    " Font debugging -- draw bounds around each glyph
    " FVimFontDrawBounds v:true
    "
    " UI options (all default to v:false)
    " external popup menu
    FVimUIPopupMenu v:false
    " external wildmenu -- work in progress
    FVimUIWildMenu v:false

    " Keyboard mapping options
    " disable unsupported sequence <S-Space>
    FVimKeyDisableShiftSpace v:true
    " Automatic input method engagement in Insert mode
    FVimKeyAutoIme v:true
    " Recognize AltGr. Side effect is that <C-A-Key> is then impossible
    FVimKeyAltGr v:true

    " Default options (workspace-agnostic)
    " FVimDefaultWindowWidth 1600     " Default window size in a new workspace
    " FVimDefaultWindowHeight 900

    " Detach from a remote session without killing the server
    " If this command is executed on a standalone instance,
    " the embedded process will be terminated anyway.
    " FVimDetach

    " =========== BREAKING CHANGES -- the following commands are disabled ============
    " FVimUIMultiGrid v:true     -- per-window grid system -- done and enabled by default
    " FVimUITabLine v:false      -- external tabline -- not implemented
    " FVimUICmdLine v:false      -- external cmdline -- not implemented
    " FVimUIMessages v:false     -- external messages -- not implemented
    " FVimUITermColors v:false   -- not implemented
    " FVimUIHlState v:false      -- not implemente
endif
