return {
  "nvzone/floaterm",
  opts = {
    size = { h = 85, w = 90 },
  },
  specs = {
    {
      "AstroNvim/astrocore",
      ---@type AstroCoreOpts
      opts = {
        mappings = {
          n = {
            -- exact casing matches the original definitions so lazy.nvim's
            -- opts merge overrides them directly (core toggleterm.lua uses
            -- "<Leader>tf"; astrocommunity's floaterm uses "<leader>tF")
            ["<Leader>tf"] = { "<cmd>FloatermToggle<cr>", desc = "Toggle Floaterm (NvZone)" },
            ["<leader>tF"] = { "<Cmd>ToggleTerm direction=float<CR>", desc = "ToggleTerm float" },
          },
        },
      },
    },
  },
}
