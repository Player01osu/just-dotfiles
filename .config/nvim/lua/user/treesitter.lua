local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	ensure_installed = {
		"rust",
		"haskell",
		"go",
		"latex",
		"c",
		"cpp",
		"html",
		"javascript",
		"java",
		"odin",
		"lua",
		"gitcommit",
		"gitignore",
		"ocaml",
		"bash",
		"python",
		"hyprlang",
		"commonlisp",
		"scheme",
		"toml",
		"yaml",
		"norg",
		"markdown",
		"markdown_inline",
	},
	sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
	ignore_install = { "" }, -- List of parsers to ignore installing
	autopairs = {
		enable = true,
	},
	highlight = {
		enable = true, -- false will disable the whole extension
		--disable = { "tex", "latex" },
		additional_vim_regex_highlighting = false,
	},
	indent = { enable = true, disable = { "yaml" } },
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
	},
})

--local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
--parser_config.nim = {
--  install_info = {
--    url = "~/Downloads/git/tree-sitter-nim", -- local path or git repo
--    files = {"src/parser.c", "src/scanner.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
--    -- optional entries:
--    branch = "main", -- default branch in case of git repo if different from master
--    generate_requires_npm = false, -- if stand-alone parser without npm dependencies
--    requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
--  },
--}
--
