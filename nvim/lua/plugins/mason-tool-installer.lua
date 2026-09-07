return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  opts = function(_, opts)
    -- drop hadolint from the list AstroNvim ships by default
    opts.ensure_installed = vim.tbl_filter(function(tool) return tool ~= "hadolint" end, opts.ensure_installed or {})
  end,
}
