vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true })

-- Tab to navigate the completion menu
vim.cmd('set wildcharm=<Tab>')


vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

-- copy to clipboard in visual and copy the whole line in normal mode
vim.api.nvim_set_keymap('v', 'Y', '"+y', { noremap = true })
vim.api.nvim_set_keymap('n', 'Y', '"+yy', { noremap = true })

vim.o.encoding = "UTF-8"

-- Map the key combination to move the visual selection one line up with [
vim.api.nvim_set_keymap('x', '[', ":move '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Map the key combination to move the visual selection one line down with ]
vim.api.nvim_set_keymap('x', ']', ":move '>+1<CR>gv=gv", { noremap = true, silent = true })


-- Install package manager
--    https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

--dap shortcutes
vim.api.nvim_set_keymap('n', '<leader>bp', ':lua require"dap".toggle_breakpoint()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dsi', ':lua require"dap".step_over()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dc', ':lua require"dap".continue()', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>di', ':lua require"dap".repl.open()', { noremap = true, silent = true })

-- jester shortcutes
vim.api.nvim_set_keymap('n', '<leader>rt', ':lua require"jester".run()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>rf', ':lua require"jester".run_file()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>rl', ':lua require"jester".run_last()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dt', ':lua require"jester".debug()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>df', ':lua require"jester".debug_file()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dl', ':lua require"jester".debug_last()<CR>', { noremap = true, silent = true })


require("lazy").setup({

	{
    	'mfussenegger/nvim-dap',
    	config = function()
      	local dap = require('dap')

	dap.adapters.node2 = {
  		type = 'executable',
  		command = 'node-debug2-adapter',
  		args = {},
	}

    	end,
  	},


	-- jester
	'David-Kunz/jester', 


	{ -- Friendly Snippets:
        "rafamadriz/friendly-snippets",
        after = "L3MON4D3/LuaSnip",  -- Ensure LuaSnip is loaded before
        config = function()
            local ls = require("luasnip")

            -- Extend 'typescript' and 'typescriptreact' filetypes to include 'javascript' and 'javascriptreact' snippets respectively
            ls.filetype_extend("typescript", { "javascript" })
            ls.filetype_extend("typescriptreact", { "javascriptreact", "typescript", "javascript" })

            -- Continue with lazy loading of VSCode snippets
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    	},

--[[ 
	{
        -- vim-snippets:
        "honza/vim-snippets",
        after = "L3MON4D3/LuaSnip",  -- Ensure LuaSnip is loaded before
        config = function()
            require("luasnip.loaders.from_snipmate").lazy_load()  -- Load SnipMate-style snippets
        end,
    	},
 ]]

	-- autoclose brackets
	{ 'm4xshen/autoclose.nvim',
		config = function()
			require("autoclose").setup({
				keys = {
      					["("] = { escape = false, close = true, pair = "()" },
      					["["] = { escape = false, close = true, pair = "[]" },
      					["{"] = { escape = false, close = true, pair = "{}" },

      					[">"] = { escape = true, close = false, pair = "<>" },
      					[")"] = { escape = true, close = false, pair = "()" },
      					["]"] = { escape = true, close = false, pair = "[]" },
      					["}"] = { escape = true, close = false, pair = "{}" },

      					['"'] = { escape = true, close = true, pair = '""' },
      					["'"] = { escape = true, close = true, pair = "''" },
      					["`"] = { escape = true, close = true, pair = "``" },
   				},
   				options = {
      					disabled_filetypes = { "text" },
      					disable_when_touch = false,
      					touch_regex = "[%w(%[{]",
      					pair_spaces = false,
      					auto_indent = true,
      					disable_command_mode = false,
   				},
			})
			end,


	},


	{ -- nvim-tree:
		"nvim-tree/nvim-tree.lua",
		version = "*",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup({

		})
		end,
	},


  	-- editorconfig
	"editorconfig/editorconfig-vim",


  	-- Git related plugins
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",


	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",

			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{"j-hui/fidget.nvim", tag = 'legacy', opts = {} },

			-- Additional lua configuration, makes nvim stuff amazing!
			"folke/neodev.nvim",
		},
	},


 	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
	},


	-- Useful plugin to show you pending keybinds.
	{ "folke/which-key.nvim", opts = {} },
	{ -- Adds git releated signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},


	{ -- Theme inspired by Atom
		-- "navarasu/onedark.nvim",
		-- "ellisonleao/gruvbox.nvim",
		"oxfist/night-owl.nvim",
		
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("night-owl")
		end,
	},


	{ -- Set lualine as statusline
		"nvim-lualine/lualine.nvim",
		-- See `:help lualine.txt`
		opts = {
			options = {
        theme = 'onedark',
        icons_enabled = true,
				component_separators = "|",
				section_separators = "",
			},
		},
	},


 	{ -- Add indentation guides even on blank lines
		"lukas-reineke/indent-blankline.nvim",
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help indent_blankline.txt`
		opts = {
			char = "┊",
			show_trailing_blankline_indent = false,
		},
	},


	-- "gc" to comment visual regions/lines
	{ "numToStr/Comment.nvim", opts = {} },


	-- Fuzzy Finder (files, lsp, etc)
	{ "nvim-telescope/telescope.nvim", version = "*", dependencies = { "nvim-lua/plenary.nvim" } },


	{
		"nvim-telescope/telescope-fzf-native.nvim",
		--       refer to the README for telescope-fzf-native for more instructions.
		build = "make",
		cond = function()
			return vim.fn.executable("make") == 1
		end,
	},


	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			pcall(require("nvim-treesitter.install").update({ with_sync = true }))
		end,
	},


	-- copilot
  	-- {'github/copilot.vim'},

  	-- require 'kickstart.plugins.autoformat',
	--require 'kickstart.plugins.debug',

	-- NOTE: The import below automatically adds our own plugins and configuration from `lua/custom/plugins/*.lua`
	--    We can use this folder to prevent any conflicts with this init.lua if you're interested in keeping

	--{ import = 'custom.plugins' },
	}, {})


-- [[ Setting options ]]
-- See `:help vim.o`


-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]
-- nvim-tree toggle
vim.keymap.set("n", "<F3>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<F4>", ":Copilot<CR>", { noremap = true, silent = true })


-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<C-u>"] = false,
				["<C-d>"] = false,
			},
		},
	},
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
	-- can pass additional configuration to telescope to change theme, layout, etc.
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
--
-- -- -- [[ Configure Treesitter ]]
-- -- -- See `:help nvim-treesitter`
 require("nvim-treesitter.configs").setup({
 	-- Add languages to be installed 
 	ensure_installed = { "c", "cpp", "javascript", "typescript", "lua", "python", "vim", "html", "css", "json", "yaml", "prisma" },

	-- Autoinstall languages that are not installed. Defaults to false
 	auto_install = true,

 	highlight = { enable = true},
 	indent = { enable = true, disable = { "python" } },
 	incremental_selection = {
 		enable = true,
 		keymaps = {
 			init_selection = "<c-space>",
 			node_incremental = "<c-space>",
 			scope_incremental = "<c-s>",
 			node_decremental = "<M-space>",
 		},
	},
 	textobjects = {
 		select = {
 			enable = true,
 			lookahead = true, -- Automatically jump forward to textobj
 			keymaps = {
 				--use the capture groups defined in textobjects.scm
 				["aa"] = "@parameter.outer",
 				["ia"] = "@parameter.inner",
 				["af"] = "@function.outer",
 				["if"] = "@function.inner",
 				["ac"] = "@class.outer",
 				["ic"] = "@class.inner",
 			},
 		},
 		move = {
 			enable = true,
 			set_jumps = true, -- whether to set jumps in the jumplist
 			goto_next_start = {
 				["]m"] = "@function.outer",
 				["]]"] = "@class.outer",
 			},
 			goto_next_end = {
 				["]M"] = "@function.outer",
 				["]["] = "@class.outer",
 			},
 			goto_previous_start = {
 				["[m"] = "@function.outer",
 				["[["] = "@class.outer",
 			},
 			goto_previous_end = {
 				["[M"] = "@function.outer",
 				["[]"] = "@class.outer",
 			},
 		},
 		swap = {
 			enable = true,
 			swap_next = {
 				["<leader>a"] = "@parameter.inner",
 			},
 			swap_previous = {
 				["<leader>A"] = "@parameter.inner",
 			},
 		},
 	},
 })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
	-- for LSP related items. sets the mode, buffer and description each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })
end

-- Enable language servers
--  the `settings` field of the server config. look up documentation 
local servers = {
	-- clangd = {},
	-- gopls = {},
	-- pyright = {},
	-- rust_analyzer = {},
	tsserver = {},

	--lua_ls = {
	--	Lua = {
	--		workspace = { checkThirdParty = false },
	--		telemetry = { enable = false },
	--	},
	--},
}

-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp broadcast additional completion capabilities to the server
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require("mason").setup()

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
		})
	end,
})

-- nvim-cmp setup
--local cmp = require("cmp")
local luasnip = require("luasnip")
local cmp = require 'cmp'

luasnip.config.setup({})

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<A-e>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<A-q>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
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

vim.cmd('source /home/krasyo/.config/nvim/copilot.vim')
