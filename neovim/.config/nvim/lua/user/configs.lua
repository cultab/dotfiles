local M = {}

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

-- our picker function: colors
M.config_picker = function(opts)
  opts = opts or {}

    pickers.new(opts, {
        prompt_title = "Open Configuration for:",
        finder = finders.new_table {
            results = {
                { "bspwm", "~/.config/bspwm/bspwmrc" },
                { "Dunst", "~/.config/dunst/no_theme.dunstrc" },
                { "Polybar", "~/.config/polybar/config.ini" },
                { "neovim", "~/.config/nvim/init.lua", true },
                { "Simple X keybind daemon", "~/.config/sxhkd/sxhkdrc" },
                { "xresources", "~/.config/xrdb/Xresources.xdefaults" },
                { "Zoomer_Shell", "~/.config/zsh/.zshrc" },
                { "themr", "~/.config/themr/themes.yaml" },
            },
            entry_maker = function(entry)
                return {
                    value = entry[1],
                    display = entry[1],
                    ordinal = entry[1],
                    path = vim.fn.expand(entry[2]),
                    cd = entry[3]
                }
            end
        },
        sorter = conf.generic_sorter(opts),
        previewer = conf.file_previewer(opts),
        attach_mappings = function(prompt_bufnr) -- , map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if selection.cd then
                    vim.cmd('cd ' .. vim.fs.dirname(selection.path))
                end
                vim.cmd('e ' .. selection.path)
            end)
            return true
        end,
    }):find()
end

return M
