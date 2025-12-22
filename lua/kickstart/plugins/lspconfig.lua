return {
  {
    -- LazyDev for Lua LSP support
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  {
    -- Main LSP setup
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'Hoffs/omnisharp-extended-lsp.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      local lspconfig = require 'lspconfig'
      local mason_lspconfig = require 'mason-lspconfig'
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      --------------------------------------------------------------------------
      --  LSP Attach (Kickstart style)
      --------------------------------------------------------------------------
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            local mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          ----------------------------------------------------------------------
          -- OmniSharp-Extended: override definition keymaps if using OmniSharp
          ----------------------------------------------------------------------
          if client.name == 'omnisharp' then
            local omnisharp_extended = require 'omnisharp_extended'
            map('gd', omnisharp_extended.telescope_lsp_definitions, '[G]oto [D]efinition')
          else
            map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
            map('gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
            map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          end

          -- Common mappings
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gq', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('gh', vim.lsp.buf.hover, 'Show [H]over information')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Document Symbols')
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace Symbols')

          -- Highlight references
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
          end

          -- Inlay hints toggle
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      --------------------------------------------------------------------------
      -- Diagnostic UI
      --------------------------------------------------------------------------
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(d)
            return d.message
          end,
        },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
      }

      --------------------------------------------------------------------------
      -- LSP Servers
      --------------------------------------------------------------------------
      local servers = {
        ts_ls = {},
        eslint = {},
        bashls = {},
        angularls = {},
        dockerls = {},
        docker_compose_language_service = {},
        gopls = {},
        html = {},
        jsonls = {},
        cssls = {},
        yamlls = {},
        mdx_analyzer = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
            },
          },
        },
        omnisharp = {
          cmd = {
            'OmniSharp',
            '-z',
            '--languageserver',
            '--hostPID',
            tostring(vim.fn.getpid()),
          },
          root_dir = function(fname)
            -- Don't attach to metadata files
            if fname:match '%$metadata%$' then
              return nil
            end
            -- Use normal root detection for real files
            return require('lspconfig.util').root_pattern('*.sln', '*.csproj', '.git')(fname)
          end,
          on_attach = function(client, bufnr)
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            if bufname:match '%$metadata%' then
              vim.schedule(function()
                vim.lsp.buf_detach_client(bufnr, client.id)
              end)
              return
            end
          end,
          autostart = true,
          single_file_support = false,
          settings = {
            FormattingOptions = {
              EnableEditorConfigSupport = true,
              OrganizeImports = true,
            },
            RoslynExtensionsOptions = {
              EnableAnalyzersSupport = true,
              EnableImportCompletion = true,
            },
          },
          handlers = {
            ['textDocument/definition'] = require('omnisharp_extended').handler,
          },
        },
      }

      --------------------------------------------------------------------------
      -- Mason Install Management
      --------------------------------------------------------------------------
      local ensure_installed = vim.tbl_keys(servers)
      vim.list_extend(ensure_installed, { 'stylua', 'omnisharp' })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      mason_lspconfig.setup {
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            lspconfig[server_name].setup(server)
          end,
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
