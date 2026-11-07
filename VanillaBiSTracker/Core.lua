VanillaBiSTracker = {}
local VBT = VanillaBiSTracker
VBT.version = "0.1.1"
VBT.phase = 3
VBT.classes = {
  WARRIOR = {"Arms", "Fury", "Protection"},
  PALADIN = {"Holy", "Protection", "Retribution"},
  HUNTER = {"Beast Mastery", "Marksmanship", "Survival"},
  ROGUE = {"Assassination", "Combat", "Subtlety"},
  PRIEST = {"Discipline", "Holy", "Shadow"},
  SHAMAN = {"Elemental", "Enhancement", "Restoration"},
  MAGE = {"Arcane", "Fire", "Frost"},
  WARLOCK = {"Affliction", "Demonology", "Destruction"},
  DRUID = {"Balance", "Feral Combat", "Restoration"},
}
VBT.slots = { "Head", "Neck", "Shoulders", "Back", "Chest", "Wrists", "Hands", "Waist", "Legs", "Feet", "Ring 1", "Ring 2", "Trinket 1", "Trinket 2", "Main Hand", "Off Hand", "Ranged" }

function VBT:Print(message)
  DEFAULT_CHAT_FRAME:AddMessage("|cff80d4ffVanilla BiS Tracker:|r " .. tostring(message))
end

function VBT:DetectCharacter()
  local className, classToken = UnitClass("player")
  local raceName, raceToken = UnitRace("player")
  self.class = classToken
  self.race = raceToken
  self.faction = UnitFactionGroup("player")
  self.characterName = UnitName("player")
  self.realm = GetRealmName()
  self:DetectTalentSpec()
end

function VBT:DetectTalentSpec()
  -- Vanilla 1.12 GetTalentTabInfo(tab) returns name, icon, pointsSpent.
  -- Unlike later clients the points count is the THIRD return value.
  if not GetNumTalentTabs or not GetTalentTabInfo then return end
  local bestIndex, bestPoints, total, tied = nil, -1, 0, false
  local trees = {}
  for tab = 1, GetNumTalentTabs() do
    local name, icon, points = GetTalentTabInfo(tab)
    points = tonumber(points) or 0
    trees[tab] = { name = name or "?", points = points }
    total = total + points
    if points > bestPoints then
      bestIndex, bestPoints, tied = tab, points, false
    elseif points == bestPoints then
      tied = true
    end
  end
  self.talentTrees = trees
  self.detectedSpec = nil
  if total > 0 and not tied and self.class and self.classes[self.class] then
    self.detectedSpec = self.classes[self.class][bestIndex]
  end
end
function VBT:PrintTalentDebug()
  self:DetectTalentSpec()
  local summary = ""
  for i, tab in ipairs(self.talentTrees or {}) do
    summary = summary .. (i > 1 and " / " or "") .. tab.name .. ": " .. tab.points
  end
  self:Print("Talents: " .. (summary ~= "" and summary or "unavailable") ..
    ". Auto: " .. (self.detectedSpec or "unknown") ..
    ". Selected: " .. (self:GetSpec() or "none"))
end

function VBT:GetSpec()
  if VBTCharDB and VBTCharDB.specOverride then return VBTCharDB.specOverride end
  return self.detectedSpec
end

function VBT:GetPhase()
  if VBTDB and VBTDB.phase then return VBTDB.phase end
  return 1
end

function VBT:Eligible(item)
  if item.phase > self:GetPhase() then return false end
  if item.pvp and not VBTDB.includePvP then return false end
  if item.class and item.class ~= self.class then return false end
  if item.race and item.race ~= self.race then return false end
  if item.faction and item.faction ~= self.faction then return false end
  return true
end

function VBT:GetRecommendations(slot)
  local spec = self:GetSpec()
  local output = {}
  if not spec or not self.class then return output end
  local key = self.class .. ":" .. spec
  local recommendations = self.recommendations[key]
  if not recommendations or not recommendations[slot] then return output end
  for _, recommendation in ipairs(recommendations[slot]) do
    local item = self.items[recommendation.id]
    if item and self:Eligible(item) and (not recommendation.phase or recommendation.phase <= self:GetPhase()) then
      table.insert(output, {item=item, rank=recommendation.rank, note=recommendation.note})
    end
  end
  table.sort(output, function(a,b) return a.rank < b.rank end)
  return output
end

function VBT:Initialize()
  if not VBTDB then VBTDB = {} end
  if not VBTCharDB then VBTCharDB = {} end
  if not VBTDB.phase or VBTDB.phase < 1 or VBTDB.phase > table.getn(self.phases) then VBTDB.phase = 1 end
  if VBTDB.includePvP == nil then VBTDB.includePvP = false end
  self:DetectCharacter()
  self:BuildUI()
  self:RefreshUI()
end

local driver = CreateFrame("Frame")
driver:RegisterEvent("PLAYER_LOGIN")
driver:RegisterEvent("PLAYER_ENTERING_WORLD")
driver:RegisterEvent("CHARACTER_POINTS_CHANGED")\ndriver:RegisterEvent("SPELLS_CHANGED")
driver:SetScript("OnEvent", function()
  if event == "PLAYER_LOGIN" then
    VBT:Initialize()
  elseif event == "CHARACTER_POINTS_CHANGED" or event == "SPELLS_CHANGED" or event == "PLAYER_ENTERING_WORLD" then
    if VBTDB and VBTCharDB then
      VBT:DetectCharacter()
      VBT:RefreshUI()
    end
  end
end)

SLASH_VBT1 = "/vbt"
SLASH_VBT2 = "/bis"
SlashCmdList["VBT"] = function(msg)
  msg = string.lower(msg or "")
  if msg == "" or msg == "toggle" then VBT:ToggleUI()
  elseif msg == "pvp" then VBTDB.includePvP = not VBTDB.includePvP; VBT:RefreshUI()
  elseif string.sub(msg, 1, 6) == "phase " then
    local n = tonumber(string.sub(msg, 7))
    if n and n >= 1 and n <= table.getn(VBT.phases) then VBTDB.phase = n; VBT:RefreshUI()
    else VBT:Print("Use /bis phase 1-" .. table.getn(VBT.phases)) end
  elseif msg == "auto" then VBTCharDB.specOverride = nil; VBT:DetectTalentSpec(); VBT:RefreshUI()\n  elseif msg == "talents" then VBT:PrintTalentDebug(); VBT:RefreshUI()
  else VBT:Print("Commands: /bis, /bis pvp, /bis phase 1-" .. table.getn(VBT.phases) .. ", /bis auto, /bis talents") end
end
