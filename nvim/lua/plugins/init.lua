return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
  	"williamboman/mason.nvim",
  	opts = {
  		ensure_installed = {
        -- lua
  			"lua-language-server",
        "stylua",
        -- web
  			"html-lsp",
        "css-lsp",
        "prettier",
        "typescript-language-server",
        "emmet-ls",
        "json-lsp",
        "eslint-lsp",
        -- shell
        "bash-language-server",
        "shfmt",
        "shellcheck",
        -- python
        "pyright",
        "black",
        -- terraform
        "terraform-ls",
        "tfsec",
        -- ansible
        "ansible-language-server",
        -- docker
        "dockerfile-language-server",
        -- yaml
        "yaml-language-server",
  		},
  	},
  },

  {
  	"nvim-treesitter/nvim-treesitter",
  	opts = {
  		ensure_installed = {
       "html", "css", "javascript", "lua",
       "bash", "dockerfile", "gitattributes",
       "gitignore", "helm", "python",
       "terraform", "yaml", "xml",
  		},
  	},
  },
  {
    "nvim-tree/nvim-web-devicons",
  },
  {
    "hashivim/vim-terraform"
  },
  {
    "kdheepak/lazygit.nvim",
    keys = {
      {
        "<leader>gg",
        "<cmd>LazyGit<CR>",
        desc = "Open LazyGit",
      }
    },
    cmd = "LazyGit"
  },
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require"alpha".setup(require"alpha.themes.startify".config)
    end
  },
}
