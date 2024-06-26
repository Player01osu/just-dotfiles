--

local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
	return
end

require("luasnip/loaders/from_vscode").lazy_load()

--local check_backspace = function()
--  local col = vim.fn.col "." - 1
--  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
--end


-- Temporary fix to https://github.com/hrsh7th/nvim-cmp/issues/1251
local abort = function()
    cmp.abort()
    cmp.core:reset()
end

--   פּ ﯟ   some other good icons
local kind_icons = {
	Text = "",
	Method = "m",
	Function = "",
	Constructor = "",
	Field = "",
	Variable = "",
	Class = "",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = "",
}
-- find more here: https://www.nerdfonts.com/cheat-sheet

cmp.setup({
	completion = {
		autocomplete = false,
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	--view = {
	--	entries = "wildmenu" -- can be "custom", "wildmenu" or "native"
	--},
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-j>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.

		["<C-e>"] = cmp.mapping(abort, { "i", "s" }),
		--["<C-e>"] = cmp.mapping({
		--	--i = cmp.mapping.abort(),
		--	i = cmp.mapping(abort, { "i", "s" }),
		--	c = cmp.mapping.close(),
		--}),
		-- Accept currently selected item. If none selected, `select` first item.
		-- Set `select` to `false` to only confirm explicitly selected items.
		["<C-y>"] = cmp.mapping.confirm({ select = true }),
	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			-- Kind icons
			vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
			-- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
			vim_item.menu = ({
				nvim_lsp = "[LSP]",
				luasnip = "[Snippet]",
				path = "[Path]",
				buffer = "[Buffer]",
			})[entry.source.name]
			return vim_item
		end,
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "path" },
		{ name = "buffer" },
		{ name = "neorg" },
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
	--documentation = {
	--  border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
	--},
	experimental = {
		ghost_text = true,
	},
})

cmp.setup.filetype({ "markdown", "help", "vimwiki", "wiki", "md", "txt", "kalker", "CommonLispInterpretter" }, {
	completion = {
		autocomplete = false,
	},
	sources = {
		{ name = "path" },
		{ name = "buffer" },
	},
})
