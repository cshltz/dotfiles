local M = {}

M.run_build = function(name, cmd, cwd)
  local result = vim.system(cmd, { cwd = cwd }):wait()
  if result.code ~= 0 then
    local stderr = result.stderr or ''
    local stdout = result.stdout or ''
    local output = stderr ~= '' and stderr or stdout
    if output == '' then
      output = 'No output from build command.'
    end
    vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
  end
end

M.hooks = {}

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local hook = M.hooks[ev.data.spec.name]
    if hook then
      hook(ev)
    end
  end,
})

return M
