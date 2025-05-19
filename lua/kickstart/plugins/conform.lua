return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = {
      async = false,
      timeout_ms = 2000,
      lsp_format = true,
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'prettier' },
      typescript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescriptreact = { 'prettier' },
      svelte = { 'prettier' },
      css = { 'prettier' },
      scss = { 'prettier' },
      html = { 'prettier' },
      json = { 'prettier' },
      yaml = { 'prettier' },
      yml = { 'prettier' },
      markdown = { 'prettier' },
      graphql = { 'prettier' },
      python = { 'isort', 'black' },
      cs = { 'csharpier' },
      csproj = { 'csharpier' },
    },
    formatters = {
      csharpier = {
        inherit = false,
        command = 'dotnet',
        args = { 'csharpier', 'format' },
        stdin = true,
      },
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
