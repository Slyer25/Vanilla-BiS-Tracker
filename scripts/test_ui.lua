-- Mock UI regression test: exercise BuildUI and RefreshUI with actual item entries.
-- This catches overwriting FontString references with source text.
SlashCmdList={}
local function widget()
  local w={}
  local methods={"SetWidth","SetHeight","SetPoint","SetText","SetJustifyH","SetJustifyV","SetBackdrop","EnableMouse","SetMovable","RegisterForDrag","SetFrameStrata","SetAllPoints","SetTexture","SetScript","SetOwner","SetHyperlink","StartMoving","StopMovingOrSizing","RegisterForClicks","SetBackdropColor","SetBackdropBorderColor","SetFrameLevel","ClearAllPoints"}
  for _, name in ipairs(methods) do
    w[name]=function(self,value,callback)
      if name=="SetText" then
        assert(type(self)=="table", "SetText invoked on non-widget")
        self.text=value
      elseif name=="SetScript" then
        self.scripts=self.scripts or {}
        self.scripts[value]=callback
      end
    end
  end
  w.CreateFontString=function() return widget() end
  w.CreateTexture=function() return widget() end
  w.Hide=function(self) self.visible=false end
  w.Show=function(self) self.visible=true end
  w.IsVisible=function(self) return self.visible end
  w.RegisterEvent=function() end
  w.GetFrameLevel=function() return 1 end
  w.GetCenter=function(self)
    if self==UIParent then return 500,400 end
    return 590,455
  end
  return w
end
UIParent=widget()
function CreateFrame(frameType, name, parent)
  local created=widget()
  created.parent=parent
  return created
end
function GetNumTalentTabs() return 3 end
function GetTalentTabInfo(i)
  local names={"Assassination","Combat","Subtlety"}
  local points={16,32,3}
  return names[i], nil, points[i]
end
function UnitClass() return "Rogue","ROGUE" end
function UnitRace() return "Night Elf","NIGHTELF" end
function UnitFactionGroup() return "Alliance" end
function UnitName() return "TestRogue" end
function GetRealmName() return "Test" end
local chatMessages={}
DEFAULT_CHAT_FRAME={AddMessage=function(self,msg) table.insert(chatMessages,msg) end}
VBTDB={phase=1, includePvP=false}
VBTCharDB={}
dofile("VanillaBiSTracker/Bootstrap.lua")
dofile("VanillaBiSTracker/Core.lua")
dofile("VanillaBiSTracker/data/Phases.lua")
dofile("VanillaBiSTracker/data/Recommendations.lua")
dofile("VanillaBiSTracker/data/GearRules.lua")
dofile("VanillaBiSTracker/data/SourceAudit.lua")
dofile("VanillaBiSTracker/GearEngine.lua")
dofile("VanillaBiSTracker/UI.lua")
local v=VanillaBiSTracker
v:Initialize()
assert(v:GetSpec()=="Combat")
assert(v:GetWeaponBuild()=="Sword","Default sword build not selected")
assert(v.weaponBuildButton.visible==true,"Build selector should show for Combat Rogue")
v:CycleWeaponBuild()
assert(v:GetWeaponBuild()=="Sword")
v:CycleWeaponBuild()
assert(v:GetWeaponBuild()=="Dagger")
v:RefreshUI()
VBTCharDB.weaponBuildOverride=nil
v:RefreshUI()
assert(v.detailFrame.parent==UIParent,"Detail frame must be independent of main window")
v:SaveWindowPosition("main",v.frame)
v:SaveWindowPosition("details",v.detailFrame)
assert(VBTCharDB.windowPositions.main.x==90 and VBTCharDB.windowPositions.details.y==55,
  "Window center offsets were not saved")
v:RestoreWindowPosition("details",v.detailFrame,160,0)
assert(v.detailFrame.parent~=v.frame,"Detail frame must not be child of main tracker")
assert(v.detailFrame.scripts.OnDragStart and v.detailFrame.scripts.OnDragStop,
  "Details window must support dragging")
assert(type(v.detailFrame.StartMoving)=="function" and type(v.detailFrame.StopMovingOrSizing)=="function")

assert(not string.find(assert(io.open("VanillaBiSTracker/UI.lua")):read("*a"), 'local shade = frame:CreateTexture', 1, true),
  "Main frame must not use separate black overlay texture")
assert(v.detailFrame and v.detailFrame.visible == false, "Item details should begin hidden")
assert(v.detailItems[1].source.text:find("Stratholme"),"Initial source missing")
assert(v.detailItems[1].itemSource=="Stratholme")
assert(v.detailItems[1].button.scripts.OnClick, "Missing item click")
arg1="LeftButton"
v.detailItems[1].button.scripts.OnClick()
assert(v.detailFrame.visible, "Left-click did not show details")
assert(string.find(v.detailSource.text,"Stratholme",1,true), "Acquisition source missing")
assert(v.detailPlanButton.scripts.OnClick,"Plan button not attached")
v.detailPlanButton.scripts.OnClick()
assert(v:IsPlanned("Head",13404),"Details did not add item to plan")
assert(string.find(v.detailItems[1].button.text,"[Plan]",1,true),"Planned marker not displayed")
v.detailPlanButton.scripts.OnClick()
assert(not v:IsPlanned("Head",13404),"Plan toggle did not remove item")

assert(not v:IsObtained(13404), "Item should initially be missing")
arg1="RightButton"
v.detailItems[1].button.scripts.OnClick()
assert(v:IsObtained(13404), "Right-click did not mark obtained")
assert(VBTCharDB.obtainedItems["13404"] == true, "Per-character persistence missing")
assert(string.find(v.detailItems[1].button.text,"[Owned]",1,true), "Missing owned indicator")
arg1="LeftButton"
v.detailObtainedButton.scripts.OnClick()
assert(not v:IsObtained(13404), "Detail button did not unmark item")
assert(not VBTCharDB.obtainedItems["13404"], "Unmark did not clear saved value")

for phase=1,7 do
  VBTDB.phase=phase
  for _, slot in ipairs(v.slots) do
    v.selectedSlot=slot
    v.detailPage=1
    v:RefreshUI()
    for _, row in ipairs(v.detailItems) do
      assert(type(row.source)=="table" and type(row.source.SetText)=="function",
        "Source widget overwritten in "..slot)
      if row.id then
        arg1="LeftButton"
        row.button.scripts.OnClick()
        assert(v.detailFrame.visible, "Details not visible for "..slot)
        assert(v.openDetailId==row.id, "Incorrect detail item for "..slot)
        v.detailFrame:Hide()
      end
    end
  end
end
VBTDB.phase=4
v.selectedSlot="Trinket 1"
v:RefreshUI()
assert(v.detailItems[1].id==19406,"BWL trinket not shown")
v.class="SHAMAN"
v.detectedSpec="Enhancement"
v.selectedSlot="Main Hand"
v:RefreshUI()
assert(v.detailItems[1].id==18538,"Shaman main hand not shown")
v.detailFrame:Show()
v.frame:Show()
v:CloseUI()
assert(v.frame.visible==false and v.detailFrame.visible==false,
  "Closing the main tracker must also close detached details")
print("PASS: independently draggable details window, per-character obtained toggle, UI clicks across phases/slots")
