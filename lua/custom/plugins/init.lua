-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- A nice way to interact with git.
  'tpope/vim-fugitive',
  -- Grab links from remote git repositories.
  {
    'linrongbin16/gitlinker.nvim',
    cmd = 'GitLink',
    opts = {},
    keys = {
      { '<leader>gy', '<cmd>GitLink<cr>', mode = { 'n', 'v' }, desc = 'Yank git link' },
      { '<leader>gY', '<cmd>GitLink!<cr>', mode = { 'n', 'v' }, desc = 'Open git link' },
    },
  },
  -- An HTTP client.
  {
    'rest-nvim/rest.nvim',
  },
  {
    'numToStr/Comment.nvim',
    opts = {},
  },
  -- roslyn LSP plugin. A replacement for Omnisharp until it's available in Mason via the following PR:
  -- https://github.com/mason-org/mason-registry/pull/6330
  -- This has problems with goto and is kinda slow while editing compared to Omnisharp.
  -- Going to stick with that probably until it makes its way into mason and gets more attention.
  --[[ {
    'seblj/roslyn.nvim',
    config = {
      -- Here you can pass in any options that that you would like to pass to `vim.lsp.start`
      -- The only options that I explicitly override are, which means won't have any effect of setting here are:
      'name',
      'cmd',
      'root_dir',
      settings = {
        ['csharp|symbol_search'] = {
          dotnet_search_reference_assemblies = false,
        },
        ['csharp|code_style'] = {
          formatting = {
            indentation_and_spacing = {
              indent_size = 4,
              indent_style = 'Spaces',
              tab_width = 4,
            },
          },
        },
        navigation = {
          dotnet_navigate_to_decompiled_sources = false,
        },
      },
    },
    exe = {
      'dotnet',
      vim.fs.joinpath(vim.fn.stdpath 'data' .. 'roslyn' .. 'Microsoft.CodeAnalysis.LanguageServer.dll'),
    },
    -- NOTE: Set `filewatching` to false if you experience performance problems.
    -- Defaults to true, since turning it off is a hack.
    -- If you notice that the server is _super_ slow, it is probably because of file watching
    -- I noticed that neovim became super unresponsive on some large codebases, and that was because
    -- it schedules the file watching on the event loop.
    -- This issue went away by disabling that capability. However, roslyn will fallback to its own
    -- file watching, which can make the server super slow to initialize.
    -- Setting this option to false will indicate to the server that neovim will do the file watching.
    -- However, in `hacks.lua` I will also just don't start off any watchers, which seems to make the server
    -- a lot faster to initialize.
    filewatching = true,
  }, ]]
}
