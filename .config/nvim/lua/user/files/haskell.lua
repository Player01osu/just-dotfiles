--vim.api.nvim_create_autocmd("FileType", {
--	pattern = { "haskell" },
--	callback = function()
--		vim.schedule(function()
--			vim.opt_local.tabstop = 3
--			vim.opt_local.softtabstop = 3
--			vim.opt_local.shiftwidth = 3
--			vim.opt_local.expandtab = true
--		end)
--	end,
--})
