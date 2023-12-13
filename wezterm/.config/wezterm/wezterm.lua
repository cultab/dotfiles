local wezterm = require 'wezterm'
local act = wezterm.action

--- @alias UserVars table

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
local function basename(s)
    return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

--- @param user_vars UserVars
local function get_proc_name(user_vars)
    local name = user_vars["WEZTERM_PROG"]

    if not name then
        return ""
    end

    -- get argv[0] only
    return string.gsub(name, ' .*', '')
end

local function isViProcess(pane, _)
    return get_proc_name(pane:get_user_vars()):find('n?vim') ~= nil
end

local function conditionalActivatePane(window, pane, pane_direction, vim_direction)
    if false and isViProcess(pane, window) then
        window:perform_action(
        -- This should match the keybinds you set in Neovim.
            act.SendKey({ key = vim_direction, mods = 'ALT' }),
            -- act.SendKey({ key = 'i', mods = 'ALT' }),
            pane
        )
    else
        window:perform_action(act.ActivatePaneDirection(pane_direction), pane)
    end
end

wezterm.on('ActivatePaneDirection-right', function(window, pane)
    conditionalActivatePane(window, pane, 'Right', 'l')
end)
wezterm.on('ActivatePaneDirection-left', function(window, pane)
    conditionalActivatePane(window, pane, 'Left', 'h')
end)
wezterm.on('ActivatePaneDirection-up', function(window, pane)
    conditionalActivatePane(window, pane, 'Up', 'k')
end)
wezterm.on('ActivatePaneDirection-down', function(window, pane)
    conditionalActivatePane(window, pane, 'Down', 'j')
end)


local config = {
    wsl_domains = {
        {
            name = 'WSL:void',
            distribution = 'void',
            -- username = "hunter",
            default_cwd = "~",
            -- default_prog = {"zsh", "-l"}
        },
    },
    font = wezterm.font_with_fallback { "Iosevka Nerd Font Mono" },
    disable_default_key_bindings = true,
    -- front_end = "Software",
    adjust_window_size_when_changing_font_size = false,
    line_height = 1.3,
    font_size = 13,
    leader = {
        key = 's',
        mods = 'CTRL',
        timeout_milliseconds = 1000
    },
    keys = {
        { key = '\\', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }, },
        { key = '-', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' }, },
        { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState, },
        { key = 'x', mods = 'LEADER', action = act.CloseCurrentTab { confirm = true }, },
        { key = 's', mods = 'LEADER', action = act.ShowTabNavigator, },
        { key = 'l', mods = 'LEADER', action = act.ShowDebugOverlay },
        { key = 'c', mods = 'LEADER', action = act.SpawnTab "CurrentPaneDomain", },
        { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1), },
        { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1), },
        { key = 'h', mods = 'ALT', action = act.EmitEvent('ActivatePaneDirection-left') },
        { key = 'j', mods = 'ALT', action = act.EmitEvent('ActivatePaneDirection-down') },
        { key = 'k', mods = 'ALT', action = act.EmitEvent('ActivatePaneDirection-up') },
        { key = 'l', mods = 'ALT', action = act.EmitEvent('ActivatePaneDirection-right') },
        { key = 's', mods = 'LEADER|CTRL', action = act.ActivateCopyMode },
        { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
        { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
        { key = '0', mods = 'CTRL', action = act.ResetFontSize },
        { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo 'ClipboardAndPrimarySelection' },
        { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },
    },
    -- enable_tab_bar = false,
    mux_output_parser_coalesce_delay_ms = 0,
    window_decorations = "INTEGRATED_BUTTONS|RESIZE",
    window_padding = {
        left = 2,
        right = 2,
        top = 2,
        bottom = 2,
    },
    color_scheme = "Catppuccin Mocha",
    -- color_scheme = "Github (base16)",
    -- color_scheme = "Github (base16)",
    launch_menu = {
        {
            label = "Open config",
            args = { "vim", "~/wezterm.lua" },
        },
        {
            label = "htop",
            args = { "htop" },
        }
    },
    hyperlink_rules = {
        -- Linkify things that look like URLs and the host has a TLD name.
        -- Compiled-in default. Used if you don't specify any hyperlink_rules.
        {
            regex = '\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b',
            format = '$0',
        },

        -- linkify email addresses
        -- Compiled-in default. Used if you don't specify any hyperlink_rules.
        {
            regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
            format = 'mailto:$0',
        },

        -- file:// URI
        -- Compiled-in default. Used if you don't specify any hyperlink_rules.
        {
            regex = [[\bfile://\S*\b]],
            format = '$0',
        },

        -- Linkify things that look like URLs with numeric addresses as hosts.
        -- E.g. http://127.0.0.1:8000 for a local development server,
        -- or http://192.168.1.1 for the web interface of many routers.
        {
            regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
            format = '$0',
        },

        -- -- Make task numbers clickable
        -- -- The first matched regex group is captured in $1.
        -- {
        --     regex = [[\b[tT](\d+)\b]],
        --     format = 'https://example.com/tasks/?t=$1',
        -- },
        --
        -- -- Make username/project paths clickable. This implies paths like the following are for GitHub.
        -- -- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wez/wezterm | "wez/wezterm.git" )
        -- -- As long as a full URL hyperlink regex exists above this it should not match a full URL to
        -- -- GitHub or GitLab / BitBucket (i.e. https://gitlab.com/user/project.git is still a whole clickable URL)
        -- {
        --     regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
        --     format = 'https://www.github.com/$1/$3',
        -- },
    },
}

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    config.default_domain = "WSL:void"
    config.font_size = 11
    config.font = nil
    config.color_scheme_dirs = { '~/.config/wezterm/colors' }
end

wezterm.on(
    'format-tab-title',
    -- function(tab, tabs, panes, config, hover, max_width)
    function(tab, _, _, _, _, _)
        local pane = tab.active_pane
        local proc_name = get_proc_name(pane.user_vars)

        if proc_name == "" or proc_name == nil then
            proc_name = "shell"
        end

        local title = tab.tab_index + 1
            .. ': '
            .. proc_name
        return {
            { Text = ' ' .. title .. ' ' },
        }
    end
)


-- window:toast_notification('wezterm', "did not match vim", nil, 4)
-- window:set_left_status("2")


return config
