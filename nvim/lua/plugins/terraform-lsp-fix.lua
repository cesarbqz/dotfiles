return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {
          on_attach = function(client, bufnr) client.server_capabilities.semanticTokensProvider = nil end,
        },
      },
    },
  },
}
