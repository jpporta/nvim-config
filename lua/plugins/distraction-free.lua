return {
	{
		"folke/zen-mode.nvim",
		dependencies = {
			{ "preservim/vim-pencil" },
			{ "folke/twilight.nvim" },
		},
		opts = {
			on_open = function()
				vim.cmd("SoftPencil")
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
