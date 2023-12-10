local fn = vim.fn
local prog_lang = { "lua", "rust", "c", "cpp", "cs", "js", "json", "html", "sh", "zsh", "bash", "conf", "java" }

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
   augroup packer_user_config
     autocmd!
     autocmd BufWritePost plugins.lua source <afile> | PackerSync
   augroup end
 ]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})
-- Install your plugins here
return packer.startup(function(use)
	use({
		ft = {'haskell', 'c', 'cpp', 'lua', 'rust', 'python', 'python2', 'nim', 'asm', 'make', 'java', 'javascript', 'kotlin', 'ocaml', 'typescript', 'go', 'elixir', 'elm', 'forth', 'html', 'json', 'toml', 'lisp', 'nix', 'netrw', 'php', 'r', 'scala', 'sql', 'swift', 'tex', 'zig'},
		'andweeb/presence.nvim',
	})

	-- Plugin manager --
	use({
		"wbthomason/packer.nvim",
	})
	use({
		"folke/neodev.nvim",
	})

	--use "ido-nvim/ido.nvim"

	-- Markdown --
	use({
		"vimwiki/vimwiki",
		branch = "dev", --ft = { "wiki" },
		config = function()
			vim.g["vimwiki_global_ext"] = 0
		end,
	})

	use({
		"folke/neoconf.nvim",
	})

	use({
		"preservim/vim-markdown",
		ft = { "md", "markdown" }, -- Markdown folding and indent
	})

	use({
		"godlygeek/tabular",
	})

	--use({
	--	"ActivityWatch/aw-watcher-vim",
	--	--run = ":AWStart",
	--})

	use({
		"nvim-neorg/neorg",
		--run = ":Neorg sync-parsers", -- This is the important bit!
		ft = { "norg" }, -- Markdown folding and indent
		config = function()
			require("neorg").setup({
				load = {
					["core.defaults"] = {},
					["core.concealer"] = {}, -- Adds pretty icons to your documents
					["core.completion"] = {
						config = {
							engine = "nvim-cmp",
						},
					},
					["core.dirman"] = {
						config = {
							workspaces = {
								home = "~/Documents/org",
							},
						},
					},
					["core.export"] = {},
					["core.keybinds"] = {
						config = {
							hook = function(keybinds)
								keybinds.map_event_to_mode("norg", {
									n = {
										{ "<Tab>",   "core.integrations.treesitter.next.link" },
										{ "<S-Tab>", "core.integrations.treesitter.previous.link" },
									},
								}, {
									silent = true,
									noremap = true,
								})
								-- Unmaps any Neorg key from the `norg` mode
								--keybinds.remap(
								--	"norg",
								--	"n",
								--	"<CR>",
								--	'<cmd>lua require("user.files.neorg_ft").normal_create_link()<cr>'
								--)
							end,
						},
					},
				},
			})
		end,
		requires = "nvim-lua/plenary.nvim",
	})

	-- Lualine --
	use({
		"nvim-lualine/lualine.nvim",
	})

	-- Colorscheme --
	--use '~/.config/nvim/lua/user/bbb'

	--use({ "rktjmp/lush.nvim", requires = { "rktjmp/shipwright.nvim" } })


	-- Indent Blankline --
	--use({
	--	"lukas-reineke/indent-blankline.nvim",
	--	ft = prog_lang,
	--})

	-- LSP --
	use({
		"neovim/nvim-lspconfig", -- enable LSP
	})

	use({
		"williamboman/mason.nvim",
	})

	use({
		"williamboman/mason-lspconfig.nvim",
	})

	use({
		"tamago324/nlsp-settings.nvim", -- language server settings defined in json for
	})

	-- Completion plugins --
	use({
		"hrsh7th/nvim-cmp", -- The completion plugin
	})

	use({
		"hrsh7th/cmp-buffer", -- buffer completions
	})

	use({
		"hrsh7th/cmp-path", -- path completions
	})

	use({
		"hrsh7th/cmp-cmdline", -- cmdline completions
	})

	use({
		"saadparwaiz1/cmp_luasnip", -- snippet completions
	})

	use({
		"hrsh7th/cmp-nvim-lsp",
	})

	use({
		"windwp/nvim-autopairs", -- Autopairs, integrates with both cmp and treesitter
	})

	use({
		"simrat39/rust-tools.nvim",
	})

	-- Snippets --
	use({
		"L3MON4D3/LuaSnip", --snippet engine
	})
	use({
		"rafamadriz/friendly-snippets", -- a bunch of snippets to use
	})

	-- Telescope --
	use({
		"nvim-telescope/telescope.nvim",
	})

	use({
		"nvim-lua/popup.nvim",
	})

	use({
		"nvim-lua/plenary.nvim",
	})

	-- Git --
	use({
		"tpope/vim-fugitive",
	})

	use({
		"kyazdani42/nvim-web-devicons",
	})

	-- Treesitter --
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false
		},
	})

	use({
		"stevearc/oil.nvim",
		config = function ()
			require("oil").setup({
				default_file_explorer = true,
				cleanup_delay_ms = 1000,
				columns = {
					"icon",
					"permissions",
					"size",
					"mtime",
				},
				view_options = {
					-- Show files and directories that start with "."
					show_hidden = true,
					is_always_hidden = function(name, _)
						return name == ".." or name == "."
					end,
				},
			})
		end
	})

	use({
		"nvim-treesitter/playground",
	})

	use({
		"lewis6991/impatient.nvim",
	})

	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
