local util = require("utils.util")

return {
	name = "tsserver",
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	root_dir = function(fname)
		local project_files = {
			"tsconfig.json",
			"jsconfig.json",
			"package.json",
			"vite.config.ts",
			"vite.config.js",
			"next.config.js",
			"nuxt.config.ts",
			"angular.json",
			"svelte.config.js",
		}

		local root = util.root_pattern(unpack(project_files))(fname)

		if not root then
			local path = util.path.dirname(fname)
			if path:match("node_modules") then
				return nil
			end

			if util.path.extname(fname) == ".ts" 
				or util.path.extname(fname) == ".js"
				or util.path.extname(fname) == ".tsx"
				or util.path.extname(fname) == ".jsx"
				then
				return util.path.dirname(fname)
			end

			return nil
		end

		return root
	end,
	capabilities = vim.lsp.protocol.make_client_capabilities(),
	settings = {
		typescript = {
			suggest = { completeFunctionCalls = true },
			inlayHints = {
				parameterNames = { enabled = "all" },
				parameterTypes = { enabled = true },
				variableTypes = { enabled = true },
			}
		},
		javascript = {
			suggest = { completeFunctionCalls = true },
			inlayHints = {
				parameterNames = { enabled = "all" },
				parameterTypes = { enabled = true },
				variableTypes = { enabled = true },
			}
		},
		diagostics = {
			enable = true,
			disable = { "undefined-field" },
			globals = { "vim" }
		}
	},
	single_file_support = true,
	telemetry = {
		enable = false
	}
}
