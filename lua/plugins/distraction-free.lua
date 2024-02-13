return {
	{ "preservim/vim-pencil" },
	{ "folke/twilight.nvim" },
	{
		"folke/zen-mode.nvim",
		opts = {
			on_open = function()
				vim.cmd("Pencil")
				vim.cmd("TwilightEnable")
			end,
			on_close = function()
				vim.cmd("PencilOff")
				vim.cmd("TwilightDisable")
			end,
		},
		keys = {
			{ "<leader>z", "<cmd>ZenMode<CR>", { desc = "Zen Mode" } },
		},
	},
}
