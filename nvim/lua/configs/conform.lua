local options = {
  formatters_by_ft = {
    css = { "prettier" },
    html = { "prettier" },
    yaml = { "prettier" },
    json = { "prettier" },
    lua = { "prettier" },
    shell = { "shfmt", "shellcheck"},
    python = { "black" },
    terraform = { "terraform_fmt"},
    tf = {"terraform_fmt"}
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

require("conform").setup(options)
