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

local prog_lang = {'haskell', 'c', 'cpp', 'lua', 'rust', 'python', 'python2', 'nim', 'asm', 'make', 'java', 'javascript', 'kotlin', 'ocaml', 'typescript', 'go', 'elixir', 'elm', 'forth', 'html', 'json', 'toml', 'lisp', 'nix', 'netrw', 'php', 'r', 'scala', 'sql', 'swift', 'tex', 'zig'}

require("lazy").setup({
	{
		"vimwiki/vimwiki",
		branch = "dev", --ft = { "wiki" },
		config = function()
			vim.g["vimwiki_global_ext"] = 0
		end,
	},
	{
		"preservim/vim-markdown",
		ft = { "md", "markdown" }, -- Markdown folding and indent
	},
	{
		"godlygeek/tabular",
		cmd = "Tabularize",
	},
	--[[
	{
		"nvim-neorg/neorg",
		ft = { "norg" }, -- Markdown folding and indent
		dependencies = { "nvim-lua/plenary.nvim", "vhyrro/luarocks.nvim" },
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
	},
	--]]

	-- Completion plugins --
	"hrsh7th/nvim-cmp", -- The completion plugin

	{
		"hrsh7th/cmp-buffer", -- buffer completions
		enabled = false,
	},

	"hrsh7th/cmp-path", -- path completions

	"hrsh7th/cmp-cmdline", -- cmdline completions

	"saadparwaiz1/cmp_luasnip", -- snippet completions

	-- Snippets --
	"L3MON4D3/LuaSnip", --snippet engine

	"rafamadriz/friendly-snippets", -- a bunch of snippets to use

	-- Telescope --
	"nvim-telescope/telescope.nvim",

	"nvim-lua/popup.nvim",

	"nvim-lua/plenary.nvim",

	{
		"vhyrro/luarocks.nvim",
		opts = {
			luarocks_build_args = {
				"--with-lua-include=/usr/include",
			},
		},
		enabled = true,
	},

	-- Git --
	{
		"tpope/vim-fugitive",
		cmd = {"G", "Gw"},
	},

	"kyazdani42/nvim-web-devicons",
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function ()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "elixir", "haskell", "rust"},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end
	},
	{
		"stevearc/oil.nvim",
		config = function ()
			local permission_hlgroups = {
				['-'] = 'NonText',
				['r'] = 'DiagnosticSignWarn',
				['w'] = 'DiagnosticSignError',
				['x'] = 'DiagnosticSignOk',
			}

			require("oil").setup({
				default_file_explorer = true,
				cleanup_delay_ms = 1000,
				columns = {
					{
						'permissions',
						highlight = function(permission_str)
							local hls = {}
							for i = 1, #permission_str do
								local char = permission_str:sub(i, i)
								table.insert(hls, { permission_hlgroups[char], i - 1, i })
							end
							return hls
						end,
					},
					{ 'size', highlight = "Constant" },
					{ "mtime", highlight = "Special" },
				},
				view_options = {
					show_hidden = true,
					is_always_hidden = function(name, _)
						return name == ".." or name == "."
					end,
				},
				constrain_cursor = "name",
				keymaps = {
					["gX"] = {
						callback = function()
							local oil = require("oil")
							local file = oil.get_cursor_entry().name
							local dir = oil.get_current_dir()

							vim.cmd(string.format("!%s/%s", dir, file))
						end,
						desc = "Spawns file in shell"
					},
					["gp"] = {
						callback = function()
							local oil = require("oil")
							local file = oil.get_cursor_entry().name
							local dir = oil.get_current_dir()
							local path = string.format("%s/%s", dir, file)

							local permission = vim.fn.input("Set permission: ")
							if permission == nil or permission == "" then
								return
							end

							os.execute(string.format("chmod %s '%s'", permission, path))
						end
					},
				},
			})
		end
	},

	{
		"rktjmp/lush.nvim",
		cmd = "Shipwrite",
		requires = { "rktjmp/shipwright.nvim" }
	},

	{
		"nvim-treesitter/playground",
		cmd = "TSPlaygroundToggle",
	},
})
