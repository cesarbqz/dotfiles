return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  opts = function(_, opts)
    -- quita hadolint de la lista que Astro trae por defecto
    opts.ensure_installed = vim.tbl_filter(function(tool) return tool ~= "hadolint" end, opts.ensure_installed or {})
  end,
}
