return {
  "yetone/avante.nvim",
  opts = {
    provider = "openai",
    auto_suggestions_provider = "openai",
    providers = {
      openai = {
        api_key_name = "OPENAI_API_KEY",
        endpoint = "https://api.openai.com/v1/chat/completions",
        model = "gpt-4", -- "gpt-4", -- o "gpt-3.5-turbo"
        timeout = 30000,
        extra_request_body = {
          temperature = 0.3,
          max_tokens = 4096,
          functions = vim.NIL,
          tool_choice = vim.NIL,
        },
      },
    },
  },
}
