local M = {}
function M:setup()
	local jdtls = require("jdtls")

	-- Project workspace
	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
	local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspaces/" .. project_name

	-- Get JDTLS installation path dynamically from Mason
	local mason_packages_dir = vim.fn.expand("$MASON/packages/")

	-- Find the launcher jar dynamically
	local plugins_path = mason_packages_dir .. "jdtls/plugins/"
	local jar_file = vim.fn.glob(plugins_path .. "org.eclipse.equinox.launcher_*.jar")

	-- Config directory per OS
	local system = vim.loop.os_uname().sysname
	local config_dir
	if system == "Linux" then
		config_dir = mason_packages_dir .. "jdtls/config_linux"
	elseif system == "Darwin" then
		config_dir = mason_packages_dir .. "jdtls/config_mac"
	elseif system:match("Windows") then
		config_dir = mason_packages_dir .. "jdtls/config_win"
	else
		error("Unsupported OS: " .. system)
	end

	-- Lombok jar path
	local lombok_jar = mason_packages_dir .. "jdtls/lombok.jar"

	-- Command to start JDTLS
	local cmd = {
		vim.fn.exepath("java"),
		("-javaagent:%s"):format(lombok_jar), -- Lombok support
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-jar",
		jar_file,
		"-configuration",
		config_dir,
		"-data",
		workspace_dir,
	}

	local config = {
		cmd = cmd,
		root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
		settings = { java = {} },
		init_options = { bundles = {} },
		capabilities = require("blink.cmp").get_lsp_capabilities(),
		on_attach = function(client, bufnr)
			local opts = { buffer = bufnr, noremap = true, silent = true }
			local jdtls = require("jdtls")

			vim.keymap.set("n", "<leader>oi", jdtls.organize_imports, opts)
			vim.keymap.set("v", "<leader>ev", function()
				jdtls.extract_variable(true)
			end, opts)
			vim.keymap.set("n", "<leader>ec", jdtls.extract_constant, opts)
			vim.keymap.set("v", "<leader>em", jdtls.extract_method, opts)
		end,
	}

	jdtls.start_or_attach(config)
end
return M
