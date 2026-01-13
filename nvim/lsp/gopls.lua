local function identify_go_dir(custom_args)
  local cmd = { 'go', 'env', custom_args.envvar_id }
  local dir = nil
  vim.system(cmd, { text = true }, function(output)
    local res = vim.trim(output.stdout or '')
    if output.code == 0 and res ~= '' then
      if custom_args.custom_subdir and custom_args.custom_subdir ~= '' then
        res = res .. custom_args.custom_subdir
      end
      dir = res
    else
      vim.schedule(function()
        vim.notify(
          ('[gopls] identify ' .. custom_args.envvar_id .. ' dir cmd failed with code %d: %s\n%s'):format(output.code, vim.inspect(cmd), output.stderr)
        )
      end)
      dir = nil
    end
  end)
  return dir
end

local function get_std_lib_dir()
  local ok, dir = pcall(identify_go_dir, { envvar_id = 'GOROOT', custom_subdir = '/src' })
  if ok then
    return dir
  else
    return nil
  end
end

local function get_mod_cache_dir()
  local ok, dir = pcall(identify_go_dir, { envvar_id = 'GOMODCACHE' })
  if ok then
    return dir
  else
    return nil
  end
end

local function get_root_dir(fname, mod_cache, std_lib)
  if mod_cache and fname:sub(1, #mod_cache) == mod_cache then
    local clients = vim.lsp.get_clients({ name = 'gopls' })
    if #clients > 0 then
      return clients[#clients].config.root_dir
    end
  end
  if std_lib and fname:sub(1, #std_lib) == std_lib then
    local clients = vim.lsp.get_clients({ name = 'gopls' })
    if #clients > 0 then
      return clients[#clients].config.root_dir
    end
  end
  return vim.fs.root(fname, 'go.work') or vim.fs.root(fname, 'go.mod') or vim.fs.root(fname, '.git')
end

local mod_cache = get_mod_cache_dir()
local std_lib = get_std_lib_dir()

return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = false,
        },
      },
    },
  },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(get_root_dir(fname, mod_cache, std_lib))
  end,
}
