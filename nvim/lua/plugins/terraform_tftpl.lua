return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      filetypes = {
        extension = {
          tftpl = "tftpl",
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts) vim.treesitter.language.register("yaml", "tftpl") end,
  },
}
