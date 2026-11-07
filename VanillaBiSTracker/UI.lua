local VBT = VanillaBiSTracker
local function button(parent, width, height, x, y, title)
  local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  b:SetWidth(width); b:SetHeight(height); b:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
  b:SetText(title)
  return b
end
local function label(parent, x, y, width, text)
  local f = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  f:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
  f:SetWidth(width); f:SetJustifyH("LEFT"); f:SetText(text)
  return f
end
function VBT:BuildUI()
  if self.frame then return end
  local frame = CreateFrame("Frame", "VanillaBiSTrackerFrame", UIParent)
  frame:SetWidth(650); frame:SetHeight(480)
  frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  frame:SetFrameStrata("DIALOG")
  frame:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", tile=true, tileSize=32, edgeSize=32, insets={left=11,right=12,top=12,bottom=11}})
  frame:EnableMouse(true); frame:SetMovable(true); frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", function() this:StartMoving() end)
  frame:SetScript("OnDragStop", function() this:StopMovingOrSizing() end)
  frame:Hide()
  self.frame=frame
  label(frame, 20, -18, 490, "Vanilla BiS Tracker  |  original 1.12")
  local close=button(frame, 65, 22, 561, -15, "Close")
  close:SetScript("OnClick", function() frame:Hide() end)
  self.info=label(frame, 20, -53, 610, "")
  local prev=button(frame, 20, 22, 20, -82, "<")
  prev:SetScript("OnClick",function() VBTDB.phase = math.max(1, VBTDB.phase - 1); VBT:RefreshUI() end)
  self.phaseText=label(frame, 48, -86, 320, "")
  local next=button(frame, 20, 22, 350, -82, ">")
  next:SetScript("OnClick",function() VBTDB.phase = math.min(table.getn(VBT.phases), VBTDB.phase + 1); VBT:RefreshUI() end)
  self.pvpButton=button(frame, 170, 22, 410, -82, "")
  self.pvpButton:SetScript("OnClick", function() VBTDB.includePvP = not VBTDB.includePvP; VBT:RefreshUI() end)
  self.specButton=button(frame, 170, 22, 20, -113, "")
  self.specButton:SetScript("OnClick", function()
    local specs=VBT.classes[VBT.class]
    if not specs then return end
    local current = VBTCharDB.specOverride
    if not current then
      VBTCharDB.specOverride=specs[1]
    else
      local index=0
      for i,s in ipairs(specs) do if s==current then index=i end end
      if index>=table.getn(specs) then VBTCharDB.specOverride=nil
      else VBTCharDB.specOverride=specs[index+1] end
    end
    VBT:RefreshUI()
  end)
  label(frame, 205, -120, 430, "Click to cycle: Auto, Tree 1, Tree 2, Tree 3")
  self.slotButtons={}
  for i,slot in ipairs(self.slots) do
    local col = math.floor((i-1)/9)
    local row = math.mod(i-1,9)
    local b=button(frame, 142, 25, 20+col*153, -151-row*32, slot)
    local selected=slot
    b:SetScript("OnClick",function() VBT.selectedSlot=selected; VBT:RefreshUI() end)
    self.slotButtons[i]=b
  end
  self.details=label(frame, 341, -155, 288, "")
  self.details:SetJustifyV("TOP")
  self.details:SetHeight(295)
  self.selectedSlot="Head"
end
function VBT:RefreshUI()
  if not self.frame or not VBTDB then return end
  local p=self.phases[VBTDB.phase]
  self.info:SetText((self.characterName or "?").." - "..(self.race or "?").." "..(self.class or "?").." ("..(self.faction or "?")..")")
  self.phaseText:SetText("Progression "..p.id..": "..p.name)
  self.pvpButton:SetText(VBTDB.includePvP and "PvP: Included" or "PvP: Excluded")
  self.specButton:SetText("Spec: "..(self:GetSpec() or "Unknown")..(VBTCharDB.specOverride and " (manual)" or " (auto)"))
  local recs=self:GetRecommendations(self.selectedSlot)
  local text=self.selectedSlot.."\n\n"
  if not self:GetSpec() then text=text.."Select a specialization first."
  elseif table.getn(recs)==0 then text=text.."No verified recommendations loaded for this slot and phase."
  else
    for i,entry in ipairs(recs) do
      local item=entry.item
      text=text..tostring(entry.rank)..". "..item.name.."\n"..(item.source or "Unknown source").."\n\n"
    end
  end
  self.details:SetText(text)
end
function VBT:ToggleUI()
  if not self.frame then self:Print("Not initialized yet."); return end
  if self.frame:IsVisible() then self.frame:Hide() else self:RefreshUI(); self.frame:Show() end
end
