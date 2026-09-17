---@type vim.lsp.Config
return {
  before_init = function(params, config)
    local root = config.root_dir
    local local_ts_lib = root and (root .. "/node_modules/typescript/lib/tsserverlibrary.js")

    if local_ts_lib and vim.uv.fs_stat(local_ts_lib) then
      vim.notify("ts_ls: using LOCAL typescript at " .. root, vim.log.levels.INFO)
      return
    end

    local global_root = vim.fn.trim(vim.fn.system("npm root -g"))
    local resolved_path = global_root .. "/typescript/lib"
    vim.notify("ts_ls: falling back to GLOBAL typescript at " .. resolved_path, vim.log.levels.WARN)

    params.initializationOptions = params.initializationOptions or {}
    params.initializationOptions.tsserver = params.initializationOptions.tsserver or {}
    params.initializationOptions.tsserver.path = resolved_path
  end,
}
