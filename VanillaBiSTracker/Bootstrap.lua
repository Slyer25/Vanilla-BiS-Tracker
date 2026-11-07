-- Loaded first so slash commands and loading diagnostics remain available
-- even if another addon component encounters an initialization error.
VanillaBiSTracker = VanillaBiSTracker or {}
local VBT = VanillaBiSTracker
VBT.bootstrapLoaded = true

local function log(message)
  if DEFAULT_CHAT_FRAME then
    DEFAULT_CHAT_FRAME:AddMessage("|cff80d4ffVanilla BiS Tracker:|r " .. tostring(message))
  end
end
VBT.BootLog = log

SLASH_VBT1 = "/vbt"
SLASH_VBT2 = "/bis"
SlashCmdList["VBT"] = function(msg)
  if not VBT.commandReady then
    log("Addon bootstrap loaded, but Core.lua did not finish loading. Check Lua errors and addon installation. Try /vbtstatus.")
    return
  end
  if VBT.HandleCommand then VBT:HandleCommand(msg or "") end
end

SLASH_VBTSTATUS1 = "/vbtstatus"
SlashCmdList["VBTSTATUS"] = function()
  log("Bootstrap: loaded; core: " .. (VBT.commandReady and "loaded" or "NOT loaded") ..
    "; UI: " .. (VBT.BuildUI and "loaded" or "NOT loaded") ..
    "; initialized: " .. (VBT.initialized and "yes" or "no") ..
    "; version: " .. (VBT.version or "unknown"))
end
