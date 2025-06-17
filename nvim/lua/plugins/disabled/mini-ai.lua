---@type NvPluginSpec
-- NOTE: Extend a/i neovim powers
return {
  "echasnovski/mini.ai",
  enabled = false,
  event = {
    "BufReadPost",
    "BufNewFile",
  },
  opts = {},
}
