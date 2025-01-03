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
  -- roslyn LSP plugin. A replacement for Omnisharp when it's available in Mason via the following PR:
  -- https://github.com/mason-org/mason-registry/pull/6330
  -- This no longer seems to have problems with goto. It does sometimes have weird lag with error messages
  -- while editing, though.
  -- Until it's available in Mason, I'm trying it out with the syndim/mason-registry according to this comment
  -- https://github.com/seblj/roslyn.nvim/issues/11#issuecomment-2294820871
  {
    'seblj/roslyn.nvim',
    -- Find values here: https://github.com/seblj/roslyn.nvim?tab=readme-ov-file#%EF%B8%8F-configuration
    opts = {
      config = {
        settings = {},
        --[[ on_attach = function(client)
          -- This function's definition can be found at
          -- https://github.com/seblj/roslyn.nvim/wiki#semantic-tokens
          monkey_patch_semantic_tokens(client)
        end, ]]
      },
      --[[ exe = {
        'dotnet',
        vim.fs.joinpath(vim.fn.stdpath 'data' .. 'roslyn' .. 'Microsoft.CodeAnalysis.LanguageServer.dll'),
      }, ]]
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
    },
  },
}
