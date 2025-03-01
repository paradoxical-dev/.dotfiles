-- INFO:  optional profiling; start nvim with `PROF=1 nvim`
if vim.env.PROF then
	local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
	vim.opt.rtp:append(snacks)
	require("snacks.profiler").startup({
		startup = {
			event = "UIEnter",
		},
		presets = {
			startup = {
				min_time = 0,
				sort = true,
			},
		},
	})
end
--

-- BUG: temporary fix for :Inspect command bug. See: https://github.com/neovim/neovim/issues/31675
vim.hl = vim.highlight
--

-- INFO: fix python path
--
vim.g.python3_host_prog = "~/.nix-profile/bin/python3"
--

-- INFO: bootstrap lazy.nvim
local lazypath = vim.env.LAZY or vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
    -- stylua: ignore
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
        lazypath })
end
vim.opt.rtp:prepend(lazypath)

if not pcall(require, "lazy") then
    -- stylua: ignore
    vim.api.nvim_echo(
        { { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } },
        true, {})
	vim.fn.getchar()
	vim.cmd.quit()
end
--

-- INFO: Snacks debugging
_G.dd = function(...)
	Snacks.debug.inspect(...)
end
_G.bt = function()
	Snacks.debug.backtrace()
end
vim.print = _G.dd
--

require("lazy_setup")
