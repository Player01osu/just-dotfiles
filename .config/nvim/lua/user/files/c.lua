--vim.api.nvim_create_autocmd("FileType", {
--	pattern = { "c" },
--	callback = function()
--		vim.schedule(function()
--			vim.opt_local.tabstop = 8
--			vim.opt_local.softtabstop = 8
--			vim.opt_local.shiftwidth = 8
--			vim.opt_local.expandtab = false
--		end)
--	end,
