-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

local function commit_blame_line_router(lk)
  -- Run git blame for the current line
  local cmd = {
    'git',
    'blame',
    '-L',
    string.format('%d,%d', lk.lstart, lk.lstart),
    '--porcelain',
    lk.file,
  }

  -- Check if .git-blame-ignore-revs exists and use it
  local ignore_file = vim.fn.findfile('.git-blame-ignore-revs', '.;')
  if ignore_file ~= '' then
    table.insert(cmd, 5, '--ignore-revs-file')
    table.insert(cmd, 6, ignore_file)
  end

  local output = vim.fn.system(cmd)
  -- Extract commit SHA from first line of blame output
  local blame_rev = output:match '^(%w+)'
  if not blame_rev or blame_rev == '0000000000000000000000000000000000000000' then
    error 'Failed to get blame commit'
  end
  local repo_name = lk.repo:match '^(.*)%.git$' or lk.repo
  -- Build URL using the blamed commit
  return string.format('https://github.com/%s/%s/commit/%s', lk.org, repo_name, blame_rev)
end

return {
  -- A nice way to interact with git.
  'tpope/vim-fugitive',
  -- Grab links from remote git repositories.
  {
    'linrongbin16/gitlinker.nvim',
    cmd = 'GitLink',
    opts = {
      router = {
        commit = {
          ['^github%.com'] = commit_blame_line_router,
        },
      },
    },
    keys = {
      { '<leader>gl', '<cmd>GitLink<cr>', mode = { 'n', 'v' }, desc = 'Yank git link' },
      { '<leader>gL', '<cmd>GitLink!<cr>', mode = { 'n', 'v' }, desc = 'Open git link' },
      { '<leader>gc', '<cmd>GitLink commit<cr>', mode = { 'n', 'v' }, desc = 'Yank git commit' },
      { '<leader>gC', '<cmd>GitLink! commit<cr>', mode = { 'n', 'v' }, desc = 'Open git commit' },
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
          -- monkey_patch_semantic_tokens(client)
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
  { 'Issafalcon/lsp-overloads.nvim' },
  {
    'cbochs/grapple.nvim',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', lazy = true },
    },
    opts = {
      scope = 'git', -- also try out "git_branch"
      -- icons = false, -- setting to "true" requires "nvim-web-devicons"
      -- status = false,
    },
    keys = {
      { '<leader>a', '<cmd>Grapple toggle<cr>', desc = 'Tag a file' },
      { '<C-g>', '<cmd>Grapple toggle_tags<cr>', desc = 'Toggle tags menu' },

      { '<C-1>', '<cmd>Grapple select index=1<cr>', desc = 'Select first tag' },
      { '<C-2>', '<cmd>Grapple select index=2<cr>', desc = 'Select second tag' },
      { '<C-3>', '<cmd>Grapple select index=3<cr>', desc = 'Select third tag' },
      { '<C-4>', '<cmd>Grapple select index=4<cr>', desc = 'Select fourth tag' },
      { '<C-5>', '<cmd>Grapple select index=5<cr>', desc = 'Select fifth tag' },

      { '<C-S-n>', '<cmd>Grapple cycle_tags next<cr>', desc = 'Go to next tag' },
      { '<C-S-p>', '<cmd>Grapple cycle_tags prev<cr>', desc = 'Go to previous tag' },
    },
  },
  { 'towolf/vim-helm', ft = 'helm' },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      sign = { enabled = false },
      enabled = false,
    },
  },
}
