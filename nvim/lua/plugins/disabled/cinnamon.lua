---@type NvPluginSpec
-- NOTE: Smooth scrolling with Cinnamon
return {
  -- Disable the plugin 
  enabled = false,
  "declancm/cinnamon.nvim",
  event = {
    "BufReadPost",
    "BufNewFile",
  },
  opts = {
    keymaps = {
      basic = true, -- Enable the basic keymaps
      extra = false, -- Enable the extra keymaps
    },
    options = {
      delay = 7, -- Delay between each movement step (in ms)
      max_delta = {
        line = 150, -- Maximum delta for line movements
        column = 200, -- Maximum delta for column movements
      },
    },
  },
}
