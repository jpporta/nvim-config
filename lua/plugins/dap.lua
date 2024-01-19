return {
	"mfussenegger/nvim-dap",
	event = "VeryLazy",
	dependencies = {
		"rcarriga/nvim-dap-ui",
	},
	config = function()
		-- Import
		local dap, dapui = require("dap"), require("dapui")

		-- Setup
		dapui.setup()

		-- Keymaps
		vim.keymap.set("n", "<leader>dt", function()
			dap.toggle_breakpoint()
		end, { desc = "[DAP] Continue" })
		vim.keymap.set("n", "<leader>dc", function()
			dap.continue()
		end, { desc = "[DAP] Continue" })

		-- Events
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end
	end,
}
