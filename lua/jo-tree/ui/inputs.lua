local vim = vim
local Input = require("nui.input")
local popups = require("jo-tree.ui.popups")
local utils = require("jo-tree.utils")

local M = {}

local should_use_popup_input = function()
  local nt = require("jo-tree")
  return utils.get_value(nt.config, "use_popups_for_input", true, false)
end

M.show_input = function(input, callback)
 local config = require("jo-tree").config
  input:mount()

  if config.enable_normal_mode_for_inputs and input.prompt_type ~= "confirm" then
    vim.schedule(function()
      vim.cmd("stopinsert")
    end)
  end

  input:map("i", "<esc>", function()
    vim.cmd("stopinsert")
    if not config.enable_normal_mode_for_inputs or input.prompt_type == "confirm" then
      input:unmount()
    end
  end, { noremap = true })

  input:map("n", "<esc>", function()
    input:unmount()
  end, { noremap = true })

  input:map("n", "q", function()
    input:unmount()
  end, { noremap = true })

  input:map("i", "<C-w>", "<C-S-w>", { noremap = true })

  local event = require("nui.utils.autocmd").event
  input:on({ event.BufLeave, event.BufDelete }, function()
    input:unmount()
    if callback then
      callback()
    end
  end, { once = true })
end

M.input = function(message, default_value, callback, options, completion)
  if should_use_popup_input() then
    local popup_options = popups.popup_options(message, 10, options)

    local input = Input(popup_options, {
      prompt = " ",
      default_value = default_value,
      on_submit = callback,
    })

    M.show_input(input)
  else
    local opts = {
      prompt = message .. " ",
      default = default_value,
    }
    if completion then
      opts.completion = completion
    end
    vim.ui.input(opts, callback)
  end
end

M.confirm = function(message, callback)
  if should_use_popup_input() then
    local popup_options = popups.popup_options(message, 10)

    local input = Input(popup_options, {
      prompt = " y/n: ",
      on_close = function()
        callback(false)
      end,
      on_submit = function(value)
        callback(value == "y" or value == "Y")
      end,
    })

    input.prompt_type = "confirm"
    M.show_input(input)
  else
    local opts = {
      prompt = message .. " y/n: ",
    }
    vim.ui.input(opts, function(value)
      callback(value == "y" or value == "Y")
    end)
  end
end

return M
