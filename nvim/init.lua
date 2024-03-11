vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.guicursor = 'n-v-c:block,i:ver25,r-cr:hor20,o:hor50'


-- DO NOT INCLUDE THIS
-- vim.opt.rtp:append("~/personal/streamer-tools")
-- DO NOT INCLUDE THIS

local augroup = vim.api.nvim_create_augroup
local ThePrimeagenGroup = augroup('ThePrimeagen', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
  require("plenary.reload").reload_module(name)
end

autocmd('TextYankPost', {
  group = yank_group,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 40,
    })
  end,
})

autocmd({ "BufWritePre" }, {
  group = ThePrimeagenGroup,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25


-- Function to find the root directory containing Cargo.toml
function find_cargo_root(start_dir)
  local current_dir = start_dir
  while current_dir ~= "/" do
    local cargo_toml_path = current_dir .. "/Cargo.toml"
    if vim.fn.filereadable(cargo_toml_path) == 1 then
      return current_dir
    end
    current_dir = vim.fn.fnamemodify(current_dir, ":h")
  end
  return nil
end

-- Function to intelligently run a Rust project
function run_rust_project()
  local current_file_path = vim.fn.expand('%:p')
  local current_file_dir = vim.fn.expand('%:p:h')
  local root_path = find_cargo_root(current_file_dir)

  -- If we found a Cargo.toml
  if root_path then
    -- Change to the root directory and then run the project with Cargo
    vim.cmd(string.format(":!cd %s && cargo run", root_path))
  else
    -- Notify the user that no Cargo.toml was found
    print("No Cargo.toml found in the directory hierarchy.")
  end
end

function run_cpp_project()
  local current_file_path = vim.fn.expand('%:p')
  local output_bin = vim.fn.tempname()

  -- Determine the compiler
  local compiler = current_file_path:match('%.c$') and 'gcc' or 'g++'
  
  -- Compile command
  local compile_command = string.format('%s %s -o %s', compiler, current_file_path, output_bin)

  -- Execute compile command
  print('Compiling ' .. current_file_path .. '...')
  local compile_success = vim.fn.system(compile_command)

  -- Check for compilation success
  if vim.v.shell_error == 0 then
    -- Run the compiled program in a new terminal window and focus it
    local run_command = string.format("osascript -e 'tell application \"Terminal\"' -e 'do script \"%s\"' -e 'activate' -e 'end tell'", output_bin)
    vim.fn.system(run_command)
  else
    print('Compilation failed!')
    print(compile_success)
  end
end



-- Map <leader>rs to run the Rust project intelligently
vim.api.nvim_set_keymap('n', '<leader>rs', [[<Cmd>lua run_rust_project()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>rc', [[<Cmd>lua run_cpp_project()<CR>]], { noremap = true, silent = true })

--
-- -- Function to intelligently run a Rust project
-- function Run_rust_project()
--   local root_path = vim.fn.fnamemodify(vim.fn.finddir("Cargo.toml", ".;"), ":h")
--
--   -- If we found a Cargo.toml
--   if root_path ~= "" then
--     -- Change to the root directory and then run the project with Cargo
--     vim.cmd(string.format(":!cd %s && cargo run", root_path))
--   else
--     -- Notify the user that no Cargo.toml was found
--     print("No Cargo.toml found in the directory hierarchy.")
--   end
-- end
--
-- -- Map <leader>rs to run the Rust project intelligently
-- vim.api.nvim_set_keymap('n', '<leader>rs', [[<Cmd>lua Run_rust_project()<CR>]], { noremap = true, silent = true })
--
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
-- Normal Mode
-- vim.api.nvim_set_keymap('n', '1', '^', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '0', '$', { noremap = true, silent = true })

-- Insert Mode
-- vim.api.nvim_set_keymap('i', '1', '<C-o>^', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('i', '0', '<C-o>$', { noremap = true, silent = true })

-- Visual Mode
-- vim.api.nvim_set_keymap('v', '1', '^', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('v', '0', '$', { noremap = true, silent = true })


-- Map Backspace to go into Insert mode and then perform a backspace in Normal mode
vim.api.nvim_set_keymap('n', '<BS>', 'i<BS>', { noremap = true, silent = true })

-- Map Ctrl-A to select all text in Normal mode
vim.api.nvim_set_keymap('n', '<C-a>', 'ggvG', { noremap = true, silent = true })

-- Map tab to go into insert if on normal mode
vim.api.nvim_set_keymap('n', '<Tab>', 'i', { noremap = true, silent = true })



-- Map Backspace to delete the selected text and go into Insert mode in Visual mode
vim.api.nvim_set_keymap('v', '<BS>', '"_di', { noremap = true, silent = true })
-- Map <Leader>fmt to :Format in normal mode
vim.api.nvim_set_keymap('n', '<Leader>fmt', ':Format<CR>', { noremap = true, silent = true })

vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

-- Map Ctrl+t to toggle NvimTree in normal mode
vim.keymap.set('n', '<C-b>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Map Ctrl+R to run Python scripts
vim.keymap.set('n', '<C-p>', ':!python3 %<CR>', { noremap = true, silent = true })

-- Map Enter to add a new line below in normal mode
vim.keymap.set('n', '<CR>', 'o', { noremap = true, silent = true })


-- In normal mode: Format and save the file when pressing Ctrl+S
vim.api.nvim_set_keymap('n', '<C-s>', ':Format<CR>:w<CR>', { noremap = true, silent = true })

-- In insert mode: Escape to normal mode, format, save, and then return to insert mode when pressing Ctrl+S
vim.api.nvim_set_keymap('i', '<C-s>', '<ESC>:Format<CR>:w<CR>a', { noremap = true, silent = true })

-- Map Ctrl+D to duplicate line
vim.keymap.set('n', '<C-d>', ':t.<CR>', { noremap = true, silent = true })

-- Option+Up: Go to the top of the buffer
-- Option+Up: Go to the top of the buffer
-- vim.keymap.set('i', '<M-Up>', '<C-o>:call visualmulti#mark#add_cursor_above(1)<CR>', { noremap = true, silent = true })

-- Option+Down: Go to the bottom of the buffer
-- vim.keymap.set('i', '<M-Down>', '<C-o>:call visualmulti#mark#add_cursor_above(1)<CR>', { noremap = true, silent = true })

-- vim.keymap.set('n', '<M-Up>', ':silent! normal! gg<CR>', { noremap = true, silent = true })

-- Option+Down: Go to the bottom of the buffer
-- vim.keymap.set('n', '<M-Down>', ':silent! normal! G<CR>', { noremap = true, silent = true })

-- Option+Left: Go to the end of the line
vim.keymap.set('n', ',', ':silent! normal! ^<CR>', { noremap = true, silent = true })

-- Option+Right: Go to the start of the line
vim.keymap.set('n', '.', ':silent! normal! $<CR>', { noremap = true, silent = true })

-- Ctrl+F to perform a replace all in the file
vim.keymap.set('n', '<C-f>', ':%s///g<Left><Left>', { noremap = true, silent = true })

-- Move lines in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Ctrl+H and Ctrl+V for horizontal and vertical splits
-- vim.keymap.set('n', '<C-h>', ':split<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<C-v>', ':vsplit<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<C-v>', ':vsplit<CR>:enew<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-h>', ':split<CR>:enew<CR>', { noremap = true, silent = true })
-- Shift selection in visual mode
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true })

-- Ctrl+Q to quit
vim.keymap.set('n', '<C-q>', ':q<CR>', { noremap = true, silent = true })

-- Delete without yanking in normal and visual mode
vim.keymap.set('n', 'd', '"_d', { noremap = true, silent = true })
vim.keymap.set('v', 'd', '"_d', { noremap = true, silent = true })

-- Yank and also copy to system clipboard
vim.keymap.set('n', 'y', 'y:let @+=@0<CR>', { noremap = true, silent = false })
vim.keymap.set('v', 'y', 'y:let @+=@0<CR>', { noremap = true, silent = false })

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
-- vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- vim.keymap.set("n", "<leader>vwm", function()
--     require("vim-with-me").StartVimWithMe()
-- end)
-- vim.keymap.set("n", "<leader>svwm", function()
--     require("vim-with-me").StopVimWithMe()
-- end)
--
-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration
  'kyazdani42/nvim-web-devicons',
  'mg979/vim-visual-multi',
  'kyazdani42/nvim-tree.lua',
  'mfussenegger/nvim-dap',
  'folke/zen-mode.nvim',
  'github/copilot.vim',

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  'mhartington/formatter.nvim',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',  opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })
      end,
    },
  },
  -- {
  --   "EdenEast/nightfox.nvim",
  --   opts = {
  --     -- Compiled file's destination location
  --     compile_path = vim.fn.stdpath("cache") .. "/nightfox",
  --     compile_file_suffix = "_compiled", -- Compiled file suffix
  --     transparent = false,               -- Disable setting background
  --     terminal_colors = true,            -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
  --     dim_inactive = true,               -- Non focused panes set to alternative background
  --     module_default = true,             -- Default enable value for modules
  --     colorblind = {
  --       enable = true,                   -- Enable colorblind support
  --       simulate_only = false,           -- Only show simulated colorblind colors and not diff shifted
  --       severity = {
  --         protan = 0,                    -- Severity [0,1] for protan (red)
  --         deutan = 0,                    -- Severity [0,1] for deutan (green)
  --         tritan = 1,                    -- Severity [0,1] for tritan (blue)
  --       },
  --     },
  --     styles = {           -- Style to be applied to different syntax groups
  --       comments = "NONE", -- Value is any valid attr-list value `:help attr-list`
  --       conditionals = "NONE",
  --       constants = "NONE",
  --       functions = "NONE",
  --       keywords = "NONE",
  --       numbers = "NONE",
  --       operators = "NONE",
  --       strings = "NONE",
  --       types = "NONE",
  --       variables = "NONE",
  --     },
  --     inverse = { -- Inverse highlight for different types
  --       match_paren = false,
  --       visual = false,
  --       search = false,
  --     },
  --   },
  --   config = function(_, opts)
  --     require("nightfox").setup(opts) -- calling setup is optional
  --     vim.cmd [[colorscheme carbonfox]]
  --   end
  -- },

  -- {
  --   "rebelot/kanagawa.nvim",
  --   opts = {
  --     compile = false,  -- enable compiling the colorscheme
  --     undercurl = true, -- enable undercurls
  --     commentStyle = { italic = true },
  --     functionStyle = {},
  --     keywordStyle = { italic = false },
  --     statementStyle = { bold = false },
  --     typeStyle = {},
  --     transparent = false,   -- do not set background color
  --     dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
  --     terminalColors = true, -- define vim.g.terminal_color_{0,17}
  --     colors = {             -- add/modify theme and palette colors
  --       palette = {},
  --       theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
  --     },
  --     theme = "dragon",
  --   },
  --   config = function(_, opts)
  --     require("kanagawa").setup(opts) -- calling setup is optional
  --     vim.cmd [[colorscheme kanagawa]]
  --   end
  -- },
  {
    "rose-pine/neovim",
    opts = {
      disable_background = true,
      disable_float_background = false,
      disable_italics = true,
      -- -- your configuration comes here
      -- -- or leave it empty to use the default settings
      -- style = "night",        -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
      -- light_style = "day",    -- The theme is used when the background is set to light
      -- transparent = false,    -- Enable this to disable setting the background color
      -- terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
      -- styles = {
      --   -- Style to be applied to different syntax groups
      --   -- Value is any valid attr-list value for `:help nvim_set_hl`
      --   comments = { italic = true },
      --   keywords = { italic = false },
      --   functions = {},
      --   variables = {},
      --   -- Background styles. Can be "dark", "transparent" or "normal"
      --   sidebars = "dark",             -- style for sidebars, see below
      --   floats = "dark",               -- style for floating windows
      -- },
      -- sidebars = { "qf", "help" },     -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
      -- day_brightness = 0.3,            -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
      -- hide_inactive_statusline = true, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
      -- dim_inactive = false,            -- dims inactive windows
      -- lualine_bold = true,             -- When `true`, section headers in the lualine theme will be bold

    },
    config = function(_, opts)
      require("rose-pine").setup(opts) -- calling setup is optional
      vim.cmd [[colorscheme rose-pine]]
    end
  },
  -- {
  --   "ribru17/bamboo.nvim",
  --   opts = {
  --     -- Main options --
  --     style = 'vulgaris',                              -- Choose between 'vulgaris' (regular) and 'multiplex' (greener)
  --     toggle_style_key = nil,                          -- Keybind to toggle theme style. Leave it nil to disable it, or set it to a string, e.g. "<leader>ts"
  --     toggle_style_list = { 'vulgaris', 'multiplex' }, -- List of styles to toggle between (this option is essentially pointless now but will become useful if more style variations are added)
  --     transparent = false,                             -- Show/hide background
  --     term_colors = true,                              -- Change terminal color as per the selected theme style
  --     ending_tildes = false,                           -- Show the end-of-buffer tildes. By default they are hidden
  --     cmp_itemkind_reverse = false,                    -- reverse item kind highlights in cmp menu

  --     -- Change code style ---
  --     -- Options are italic, bold, underline, none
  --     -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
  --     code_style = {
  --       comments = 'italic',
  --       conditionals = 'italic',
  --       keywords = 'none',
  --       functions = 'none',
  --       strings = 'none',
  --       variables = 'none'
  --     },

  --     -- Lualine options --
  --     lualine = {
  --       transparent = true, -- lualine center bar transparency
  --     },

  --     -- Custom Highlights --
  --     colors = {},     -- Override default colors
  --     highlights = {}, -- Override highlight groups

  --     -- Plugins Config --
  --     diagnostics = {
  --       darker = false,    -- darker colors for diagnostic
  --       undercurl = true,  -- use undercurl instead of underline for diagnostics
  --       background = true, -- use background color for virtual text
  --     },
  --     -- variant = "auto",
  --     -- bold_vert_split = true,
  --     -- disable_background = true,
  --     -- -- disable_float_background = true,
  --     -- disable_italics = true,
  --     --
  --     -- --   styles = {
  --     -- --     comments = { italic = false }, -- style for comments
  --     -- --     keywords = { italic = false }, -- style for keywords
  --     -- --     identifiers = { italic = false }, -- style for identifiers
  --     -- --     functions = {}, -- style for functions
  --     -- --     variables = {}, -- style for variables
  --     -- -- },
  --     -- gamma = 0.85,
  --     -- --
  --     -- transparent_background = true,
  --     --     -- custom options here
  --   },
  --   config = function(_, opts)
  --     require("bamboo").setup(opts) -- calling setup is optional
  --     vim.cmd [[colorscheme bamboo]]
  --   end
  -- },



  {
    -- Set lualine as statuslinE
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'rose-pine',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- require("nvim-tree").setup()
-- require('nvim-tree').setup {
--     open_file = {
--           quit_on_open = false,
--   },
-- }
require("nvim-tree").setup { -- BEGIN_DEFAULT_OPTS
  on_attach = "default",
  hijack_cursor = false,
  auto_reload_on_write = true,
  disable_netrw = false,
  hijack_netrw = true,
  hijack_unnamed_buffer_when_opening = false,
  root_dirs = {},
  prefer_startup_root = false,
  sync_root_with_cwd = false,
  reload_on_bufenter = false,
  respect_buf_cwd = false,
  select_prompts = false,
  sort = {
    sorter = "name",
    folders_first = true,
    files_first = false,
  },
  view = {
    centralize_selection = false,
    cursorline = true,
    debounce_delay = 15,
    hide_root_folder = false,
    side = "left",
    preserve_window_proportions = false,
    number = false,
    relativenumber = false,
    signcolumn = "yes",
    width = 30,
    float = {
      enable = false,
      quit_on_focus_loss = true,
      open_win_config = {
        relative = "editor",
        border = "rounded",
        width = 30,
        height = 30,
        row = 1,
        col = 1,
      },
    },
  },
  renderer = {
    add_trailing = false,
    group_empty = false,
    full_name = false,
    root_folder_label = ":~:s?$?/..?",
    indent_width = 2,
    special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
    symlink_destination = true,
    highlight_git = false,
    highlight_diagnostics = false,
    highlight_opened_files = "none",
    highlight_modified = "none",
    highlight_clipboard = "name",
    indent_markers = {
      enable = false,
      inline_arrows = true,
      icons = {
        corner = "└",
        edge = "│",
        item = "│",
        bottom = "─",
        none = " ",
      },
    },
    icons = {
      web_devicons = {
        file = {
          enable = true,
          color = true,
        },
        folder = {
          enable = false,
          color = true,
        },
      },
      git_placement = "before",
      diagnostics_placement = "signcolumn",
      modified_placement = "after",
      padding = " ",
      symlink_arrow = " ➛ ",
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
        diagnostics = true,
        modified = true,
      },
      glyphs = {
        default = "",
        symlink = "",
        bookmark = "󰆤",
        modified = "●",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  update_focused_file = {
    enable = false,
    update_root = false,
    ignore_list = {},
  },
  system_open = {
    cmd = "",
    args = {},
  },
  git = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = true,
    disable_for_dirs = {},
    timeout = 400,
  },
  diagnostics = {
    enable = false,
    show_on_dirs = false,
    show_on_open_dirs = true,
    debounce_delay = 50,
    severity = {
      min = vim.diagnostic.severity.HINT,
      max = vim.diagnostic.severity.ERROR,
    },
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  modified = {
    enable = false,
    show_on_dirs = true,
    show_on_open_dirs = true,
  },
  filters = {
    git_ignored = true,
    dotfiles = false,
    git_clean = false,
    no_buffer = false,
    custom = {},
    exclude = {},
  },
  live_filter = {
    prefix = "[FILTER]: ",
    always_show_folders = true,
  },
  filesystem_watchers = {
    enable = true,
    debounce_delay = 50,
    ignore_dirs = {},
  },
  actions = {
    use_system_clipboard = true,
    change_dir = {
      enable = true,
      global = false,
      restrict_above_cwd = false,
    },
    expand_all = {
      max_folder_discovery = 300,
      exclude = {},
    },
    file_popup = {
      open_win_config = {
        col = 1,
        row = 1,
        relative = "cursor",
        border = "shadow",
        style = "minimal",
      },
    },
    open_file = {
      quit_on_open = false,
      eject = true,
      resize_window = true,
      window_picker = {
        enable = true,
        picker = "default",
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        exclude = {
          filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
          buftype = { "nofile", "terminal", "help" },
        },
      },
    },
    remove_file = {
      close_window = true,
    },
  },
  trash = {
    cmd = "trash",
  },
  tab = {
    sync = {
      open = false,
      close = false,
      ignore = {},
    },
  },
  notify = {
    threshold = vim.log.levels.INFO,
    absolute_path = true,
  },
  ui = {
    confirm = {
      remove = true,
      trash = true,
    },
  },
  experimental = {},
  log = {
    enable = false,
    truncate = false,
    types = {
      all = false,
      config = false,
      copy_paste = false,
      dev = false,
      diagnostics = false,
      git = false,
      profile = false,
      watcher = false,
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]resume' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  -- gopls = {},
  pyright = {},
  rust_analyzer = {},
  tsserver = {},
  html = { filetypes = { 'html', 'twig', 'hbs' } },
  eslint = { filetypes = { 'javascript', 'typescript', 'typescriptreact', 'javascriptreact' } },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}

-- Utilities for creating configurations
local util = require "formatter.util"

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    -- Formatter configurations for filetype "lua" go here
    -- and will be executed in order
    lua = {
      -- "formatter.filetypes.lua" defines default configurations for the
      -- "lua" filetype
      require("formatter.filetypes.lua").stylua,

      -- You can also define your own configuration
      function()
        -- Supports conditional formatting
        if util.get_current_buffer_file_name() == "special.lua" then
          return nil
        end

        -- Full specification of configurations is down below and in Vim help
        -- files
        return {
          exe = "stylua",
          args = {
            "--search-parent-directories",
            "--stdin-filepath",
            util.escape_path(util.get_current_buffer_file_path()),
            "--",
            "-",
          },
          stdin = true,
        }
      end
    },
    javascript = {
      -- Prettier formatter configuration
      function()
        return {
          exe = "prettier",
          args = { "--stdin-filepath", util.escape_path(util.get_current_buffer_file_path()), "--single-quote" },
          stdin = true
        }
      end
    },
    typescript = {
      -- Prettier formatter configuration for TypeScript
      function()
        return {
          exe = "prettier",
          args = { "--stdin-filepath", util.escape_path(util.get_current_buffer_file_path()), "--single-quote" },
          stdin = true
        }
      end
    },

    -- Use the special "*" filetype for defining formatter configurations on
    -- any filetype
    ["*"] = {
      -- "formatter.filetypes.any" defines default configurations for any
      -- filetype
      require("formatter.filetypes.any").remove_trailing_whitespace
    }
  }
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}


-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
--
--
--
