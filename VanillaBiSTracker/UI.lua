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
  local shade = frame:CreateTexture(nil, "BACKGROUND")
  shade:SetAllPoints(frame)
  shade:SetTexture(0, 0, 0, 0.88)
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
    b:SetScript("OnClick",function() VBT.selectedSlot=selected; VBT.detailPage=1; VBT:RefreshUI() end)
    self.slotButtons[i]=b
  end
  self.detailsTitle=label(frame, 343, -155, 287, "")
  self.detailsCount=label(frame, 343, -178, 287, "")
  self.detailItems={}
  for i=1,3 do
    local y = -205-(i-1)*82
    local b=button(frame, 270, 25, 343, y, "")
    local sourceText=label(frame, 346, y-28, 277, "")
    sourceText:SetHeight(42)
    local slotIndex = i
    b:SetScript("OnEnter",function()
      local entry = VBT.detailItems[slotIndex]
      if entry and entry.id and GameTooltip then
        GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
        local ok = pcall(function()
          GameTooltip:SetHyperlink("item:" .. entry.id .. ":0:0:0")
        end)
        if ok then GameTooltip:Show() else GameTooltip:Hide() end
      end
    end)
    b:SetScript("OnLeave",function() if GameTooltip then GameTooltip:Hide() end end)
    b:SetScript("OnClick",function()
      local entry=VBT.detailItems[slotIndex]
      if entry then
        VBT:Print(entry.name .. " [" .. entry.id .. "] - " .. (entry.source or "Unknown") ..
        (entry.boss and (", " .. entry.boss) or ""))
      end
    end)
    self.detailItems[i]={button=b,source=sourceText}
  end
  self.detailsPrev=button(frame, 32, 22, 351, -450, "<")
  self.detailsPrev:SetScript("OnClick",function()
    VBT.detailPage=math.max(1,(VBT.detailPage or 1)-1); VBT:RefreshUI()
  end)
  self.detailsNext=button(frame, 32, 22, 583, -450, ">")
  self.detailsNext:SetScript("OnClick",function()
    VBT.detailPage=(VBT.detailPage or 1)+1; VBT:RefreshUI()
  end)
  self.detailsPage=label(frame, 395, -453, 180, "")
  self.selectedSlot="Head"
  self.detailPage=1
end
function VBT:RefreshUI()
  if not self.frame or not VBTDB then return end
  local p=self.phases[VBTDB.phase]
  self.info:SetText((self.characterName or "?").." - "..(self.race or "?").." "..(self.class or "?").." ("..(self.faction or "?")..")")
  self.phaseText:SetText("Progression "..p.id..": "..p.name)
  self.pvpButton:SetText(VBTDB.includePvP and "PvP: Included" or "PvP: Excluded")
  self.specButton:SetText("Spec: "..(self:GetSpec() or "Unknown")..(VBTCharDB.specOverride and " (manual)" or " (auto)"))
  local recs=self:GetRecommendations(self.selectedSlot)
  local total=table.getn(recs)
  local pages=math.max(1,math.ceil(total/3))
  if not self.detailPage or self.detailPage>pages then self.detailPage=1 end
  self.detailsTitle:SetText(self.selectedSlot .. " - candidate gear")
  if not self:GetSpec() then
    self.detailsCount:SetText("Choose a specialization first.")
  elseif total == 0 then
    self.detailsCount:SetText("No curated recommendations for this slot.")
  else
    self.detailsCount:SetText(total .. " eligible candidate(s) - hover for tooltip")
  end
  for i, row in ipairs(self.detailItems) do
    local entry=recs[(self.detailPage-1)*3+i]
    if entry then
      row.id=entry.item.id
      row.name=entry.item.name
      row.source=entry.item.source
      row.boss=entry.item.boss
      row.button:SetText(((self.detailPage-1)*3+i) .. ". " .. entry.item.name)
      row.button:Show()
      row.source:SetText((entry.item.source or "Unknown source") ..
        (entry.item.boss and (" - " .. entry.item.boss) or "") ..
        (entry.note and ("\n" .. entry.note) or ""))
      row.source:Show()
    else
      row.id=nil
      row.button:Hide()
      row.source:Hide()
    end
  end
  self.detailsPage:SetText("Page " .. self.detailPage .. " / " .. pages)
  if self.detailPage>1 then self.detailsPrev:Show() else self.detailsPrev:Hide() end
  if self.detailPage<pages then self.detailsNext:Show() else self.detailsNext:Hide() end
end
function VBT:ToggleUI()
  if not self.frame then self:Print("Not initialized yet."); return end
  if self.frame:IsVisible() then self.frame:Hide() else self:RefreshUI(); self.frame:Show() end
end
