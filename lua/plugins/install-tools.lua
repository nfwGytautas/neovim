-- Automatically install required external tools for LazyVim
-- Runs once on startup if tools are missing

-- Map of tool binary name -> package name overrides per manager
-- (most tools have the same name across managers)
local tools = {
  { bin = "fd",      pkg = { default = "fd-find", brew = "fd", pacman = "fd", dnf = "fd-find", apk = "fd" } },
  { bin = "rg",      pkg = { default = "ripgrep" } },
  { bin = "fzf",     pkg = { default = "fzf" } },
  { bin = "lazygit", pkg = { default = "lazygit", brew = "lazygit" } },
  { bin = "tmux",    pkg = { default = "tmux" } },
}

local function executable(name)
  return vim.fn.executable(name) == 1
end

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "Tool Installer" })
end

local function detect_installer()
  -- macOS
  if executable("brew") then
    return "brew install %s"
  end
  -- Debian/Ubuntu
  if executable("apt-get") then
    return "sudo apt-get install -y %s"
  end
  -- Fedora/RHEL
  if executable("dnf") then
    return "sudo dnf install -y %s"
  end
  -- Arch
  if executable("pacman") then
    return "sudo pacman -S --noconfirm %s"
  end
  -- Alpine
  if executable("apk") then
    return "sudo apk add %s"
  end
  return nil
end

local function get_manager_key(install_cmd)
  if install_cmd:match("brew") then return "brew" end
  if install_cmd:match("apt") then return "default" end
  if install_cmd:match("dnf") then return "dnf" end
  if install_cmd:match("pacman") then return "pacman" end
  if install_cmd:match("apk") then return "apk" end
  return "default"
end

local function ensure_tools()
  local install_cmd = detect_installer()
  if not install_cmd then
    notify("No supported package manager found (brew/apt/dnf/pacman/apk)", vim.log.levels.WARN)
    return
  end

  local manager_key = get_manager_key(install_cmd)
  local missing = {}

  for _, tool in ipairs(tools) do
    if not executable(tool.bin) then
      local pkg = tool.pkg[manager_key] or tool.pkg.default
      table.insert(missing, { bin = tool.bin, pkg = pkg })
    end
  end

  if #missing == 0 then
    return -- all tools present
  end

  local names = vim.tbl_map(function(t) return t.bin end, missing)
  local pkgs = vim.tbl_map(function(t) return t.pkg end, missing)

  notify("Missing tools: " .. table.concat(names, ", ") .. "\nInstalling...")

  local full_cmd = string.format(install_cmd, table.concat(pkgs, " "))

  vim.fn.jobstart(full_cmd, {
    on_exit = function(_, code)
      if code == 0 then
        notify("✅ Successfully installed: " .. table.concat(names, ", "))
      else
        notify("❌ Install failed (exit " .. code .. "): " .. full_cmd, vim.log.levels.ERROR)
      end
    end,
  })
end

-- Run on VimEnter so it doesn't block startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    ensure_tools()
  end,
  once = true,
})

-- Return empty spec — this file is for side-effects only
return {}
