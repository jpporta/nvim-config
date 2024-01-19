return {
	"leoluz/nvim-dap-go",
	event = { "BufReadPre", "BufNewFile" },
	ft = "go",
	config = function()
		require("dap-go").setup()
	end,
}
