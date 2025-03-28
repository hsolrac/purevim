local util = require("utils.util")

return {
	name = "rust_analyzer",
	cmd = { "rust-analyzer" },
	filesType = { "rust" },
	single_file_support = true,
	capabilities = vim.lsp.protocol.make_client_capabilities(),
	root_dir =  function(fname)
		local reuse_active = is_library(fname)
		if reuse_active then
			return reuse_active
		end

		local cargo_crate_dir = util.root_pattern 'Cargo.toml'(fname)
		local cargo_workspace_root

		if cargo_crate_dir ~= nil then
			local cmd = {
				'cargo',
				'metadata',
				'--no-deps',
				'--format-version',
				'1',
				'--manifest-path',
				cargo_crate_dir .. '/Cargo.toml',
			}

			local result = async.run_command(cmd)

			if result and result[1] then
				result = vim.json.decode(table.concat(result, ''))
				if result['workspace_root'] then
					cargo_workspace_root = vim.fs.normalize(result['workspace_root'])
				end
			end
		end

		return cargo_workspace_root
		or cargo_crate_dir
		or util.root_pattern 'rust-project.json'(fname)
		or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
	end,
	capabilities = {
		experimental = {
			serverStatusNotification = true,
		},
	},
	before_init = function(init_params, config)
		-- See https://github.com/rust-lang/rust-analyzer/blob/eb5da56d839ae0a9e9f50774fa3eb78eb0964550/docs/dev/lsp-extensions.md?plain=1#L26
		if config.settings and config.settings['rust-analyzer'] then
			init_params.initializationOptions = config.settings['rust-analyzer']
		end
	end,
	settings = {
		["rust-analyzer"] = {
			assist = {
				importGranularity = "module",
				importPrefix = "self",
			},
			cargo = {
				loadOutDirsFromCheck = true,
			},
			procMacro = {
				enable = true,
			},
			diagnostics = {
				enable = true,
			},
			checkOnSave = {
				command = "clippy",
			},
		},
	},
} 
