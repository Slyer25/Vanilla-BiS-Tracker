-- Mock UI regression test: exercise BuildUI and RefreshUI with actual item entries.
-- This catches overwriting FontString references with source text.
SlashCmdList={}
local function widget()
  local w={}
  local methods={"SetWidth","SetHeight","SetPoint","SetText","SetJustifyH","SetJustifyV","SetBackdrop","EnableMouse","SetMovable","RegisterForDrag","SetFrameStrata","SetAllPoints","SetTexture","SetScript","SetOwner","SetHyperlink","StartMoving","StopMovingOrSizing"}
  for _, name in ipairs(methods) do
    w[name]=function(self,value,callback)
      if name=="SetText" then
        assert(type(self)=="table", "SetText invoked on non-widget")
        self.text=value
      elseif name=="SetScript" then
        self.scripts=self.scripts or {}\n        self.scripts[value]=callback
      end
    end
  end
  w.CreateFontString=function() return widget() end
  w.CreateTexture=function() return widget() end
  w.Hide=function(self) self.visible=false end
  w.Show=function(self) self.visible=true end
  w.IsVisible=function(self) return self.visible end
  w.RegisterEvent=function() end
  return w
end
UIParent=widget()
function CreateFrame() return widget() end
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
local chatMessages={}\nDEFAULT_CHAT_FRAME={AddMessage=function(self,msg) table.insert(chatMessages,msg) end}
VBTDB={phase=1, includePvP=false}
VBTCharDB={}
dofile("VanillaBiSTracker/Bootstrap.lua")
dofile("VanillaBiSTracker/Core.lua")
dofile("VanillaBiSTracker/data/Phases.lua")
dofile("VanillaBiSTracker/data/Recommendations.lua")
dofile("VanillaBiSTracker/UI.lua")
local v=VanillaBiSTracker
v:Initialize()
assert(v:GetSpec()=="Combat")
assert(v.detailItems[1].source.text:find("Stratholme"),"Initial source missing")
assert(v.detailItems[1].itemSource=="Stratholme")\nassert(v.detailItems[1].button.scripts.OnClick, "Missing click handler")\nv.detailItems[1].button.scripts.OnClick()\nassert(chatMessages[1] and string.find(chatMessages[1],"Stratholme",1,true), "Click did not print item acquisition source")
for phase=1,7 do
  VBTDB.phase=phase
  for _, slot in ipairs(v.slots) do
    v.selectedSlot=slot
    v.detailPage=1
    v:RefreshUI()
    for _, row in ipairs(v.detailItems) do
      assert(type(row.source)=="table" and type(row.source.SetText)=="function",
        "Source widget overwritten in "..slot)
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
print("PASS: mock UI renders source text, clicks every item, 7 phases, all equipment slots and two specs")
