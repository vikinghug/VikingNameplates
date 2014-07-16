require "Window"
require "Unit"
require "GameLib"
require "Apollo"
require "ApolloColor"
require "Window"

local VikingLib
local VikingNameplates = {
  _VERSION = 'VikingNameplates.lua 0.1.0',
  _URL     = 'https://github.com/vikinghug/VikingNameplates',
  _DESCRIPTION = '',
  _LICENSE = [[
    MIT LICENSE

    Copyright (c) 2014 Kevin Altman

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  ]]
}

-- GameLib.CodeEnumClass.Warrior      = 1
-- GameLib.CodeEnumClass.Engineer     = 2
-- GameLib.CodeEnumClass.Esper        = 3
-- GameLib.CodeEnumClass.Medic        = 4
-- GameLib.CodeEnumClass.Stalker      = 5
-- GameLib.CodeEnumClass.Spellslinger = 7

local tClassName = {
  [GameLib.CodeEnumClass.Warrior]      = "Warrior",
  [GameLib.CodeEnumClass.Engineer]     = "Engineer",
  [GameLib.CodeEnumClass.Esper]        = "Esper",
  [GameLib.CodeEnumClass.Medic]        = "Medic",
  [GameLib.CodeEnumClass.Stalker]      = "Stalker",
  [GameLib.CodeEnumClass.Spellslinger] = "Spellslinger"
}


local tClassToSpriteMap =
{
  [GameLib.CodeEnumClass.Warrior]       = "VikingSprites:ClassWarrior",
  [GameLib.CodeEnumClass.Engineer]      = "VikingSprites:ClassEngineer",
  [GameLib.CodeEnumClass.Esper]         = "VikingSprites:ClassEsper",
  [GameLib.CodeEnumClass.Medic]         = "VikingSprites:ClassMedic",
  [GameLib.CodeEnumClass.Stalker]       = "VikingSprites:ClassStalker",
  [GameLib.CodeEnumClass.Spellslinger]  = "VikingSprites:ClassSpellslinger"
}


local tRankToSpriteMap = {
  [Unit.CodeEnumRank.Elite]    = "spr_TargetFrame_ClassIcon_Elite",
  [Unit.CodeEnumRank.Superior] = "spr_TargetFrame_ClassIcon_Superior",
  [Unit.CodeEnumRank.Champion] = "spr_TargetFrame_ClassIcon_Champion",
  [Unit.CodeEnumRank.Standard] = "spr_TargetFrame_ClassIcon_Standard",
  [Unit.CodeEnumRank.Minion]   = "spr_TargetFrame_ClassIcon_Minion",
  [Unit.CodeEnumRank.Fodder]   = "spr_TargetFrame_ClassIcon_Fodder"
}


local tTargetMarkSpriteMap =
{
  "Icon_Windows_UI_CRB_Marker_Bomb",
  "Icon_Windows_UI_CRB_Marker_Ghost",
  "Icon_Windows_UI_CRB_Marker_Mask",
  "Icon_Windows_UI_CRB_Marker_Octopus",
  "Icon_Windows_UI_CRB_Marker_Pig",
  "Icon_Windows_UI_CRB_Marker_Chicken",
  "Icon_Windows_UI_CRB_Marker_Toaster",
  "Icon_Windows_UI_CRB_Marker_UFO"
}


local tDefaultSettings
local tNameplates = {}

function VikingNameplates:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function VikingNameplates:Init()
  Apollo.RegisterAddon(self, nil, nil, {"VikingLibrary"})
end

function VikingNameplates:OnLoad()
  self.xmlDoc = XmlDoc.CreateFromFile("VikingNameplates.xml")
  self.xmlDoc:RegisterCallback("OnDocumentReady", self)
end

function VikingNameplates:OnDocumentReady()
  if self.xmlDoc == nil then
    return
  end

  -- Apollo.RegisterEventHandler("WindowManagementReady"      , "OnWindowManagementReady"      , self)
  -- Apollo.RegisterEventHandler("WindowManagementUpdate"     , "OnWindowManagementUpdate"     , self)
  -- Apollo.RegisterEventHandler("TargetUnitChanged"          , "OnTargetUnitChanged"          , self)
  -- Apollo.RegisterEventHandler("AlternateTargetUnitChanged" , "OnFocusUnitChanged"           , self)
  -- Apollo.RegisterEventHandler("PlayerLevelChange"          , "OnUnitLevelChange"            , self)
  -- Apollo.RegisterEventHandler("UnitLevelChanged"           , "OnUnitLevelChange"            , self)
  Apollo.RegisterEventHandler("VarChange_FrameCount" , "OnFrame"         , self)
  Apollo.RegisterEventHandler("UnitCreated"          , "OnUnitCreated"   , self)
  Apollo.RegisterEventHandler("UnitDestroyed"        , "OnUnitDestroyed" , self)
  -- Apollo.RegisterEventHandler("ChangeWorld"                , "OnWorldChanged"               , self)

  self.bDocLoaded = true
  self:OnRequiredFlagsChanged()

end

function VikingNameplates:OnUnitCreated(unit)
  -- Print("Created: " .. uni t:GetName())

  -- local tFrame = self:CreateUnitFrame("Player")
  -- table.insert(tNameplates, tFrame)
  -- self:SetUnit(tFrame, unit)
  -- tFrame.wndUnitFrame:SetUnit(unit)
  -- tFrame.wndUnitFrame:Show(true, false)
  -- self:SetClass(self.tPlayerFrame)

end

function VikingNameplates:OnUnitDestroyed(unit)
  -- Print("Destroyed: " .. unit:GetName())
  -- local nameplate = self:GetNameplate(id)
  -- nameplate = nil

end

function VikingNameplates:GetNameplate(id)
  for i,v in ipairs(tNameplates) do
    if v.id == id then return v end
  end
end

function VikingNameplates:OnWindowManagementReady()
  -- Event_FireGenericEvent("WindowManagementAdd", { wnd = self.tPlayerFrame.wndUnitFrame, strName = "Viking Player Frame" })
  -- Event_FireGenericEvent("WindowManagementAdd", { wnd = self.tTargetFrame.wndUnitFrame, strName = "Viking Target Frame" })
  -- Event_FireGenericEvent("WindowManagementAdd", { wnd = self.tFocusFrame.wndUnitFrame,  strName = "Viking Focus Target" })
end


function VikingNameplates:OnRequiredFlagsChanged()
  if GameLib.GetPlayerUnit() then
    self:OnCharacterLoaded()
  else
    Apollo.RegisterEventHandler("CharacterCreated", "OnCharacterLoaded", self)
  end
end


function VikingNameplates:OnWindowManagementUpdate(tWindow)
  if tWindow and tWindow.wnd and (tWindow.wnd == self.tPlayerFrame.wndUnitFrame or tWindow.wnd == self.tTargetFrame.wndUnitFrame or tWindow.wnd == self.tFocusFrame.wndUnitFrame) then
    local bMoveable = tWindow.wnd:IsStyleOn("Moveable")

    tWindow.wnd:SetStyle("Sizable", bMoveable)
    tWindow.wnd:SetStyle("RequireMetaKeyToMove", bMoveable)
    tWindow.wnd:SetStyle("IgnoreMouse", not bMoveable)
  end
end


function VikingNameplates:OnUnitLevelChange()
  self:SetUnitLevel(self.tPlayerFrame)
  self:SetUnitLevel(self.tTargetFrame)
end


--
-- CreateUnitFrame
--
--   Builds a UnitFrame instance

function VikingNameplates:CreateUnitFrame(name)

  local sFrame = "t" .. name .. "Frame"

  local wndUnitFrame = Apollo.LoadForm(self.xmlDoc, "UnitFrame", "InWorldHudStratum" , self)

  local tFrame = {
    name          = name,
    wndUnitFrame  = wndUnitFrame,
    wndHealthBar  = wndUnitFrame:FindChild("Bars:Health"),
    wndShieldBar  = wndUnitFrame:FindChild("Bars:Shield"),
    wndAbsorbBar  = wndUnitFrame:FindChild("Bars:Absorb"),
    wndCastBar    = wndUnitFrame:FindChild("Bars:Cast"),
    wndTargetMark = wndUnitFrame:FindChild("TargetExtra:Mark"),
    bCasting      = false
  }

  -- tFrame.wndUnitFrame:SetSizingMinimum(140, 60)

  -- tFrame.locDefaultPosition = WindowLocation.new(self.db.position[name:lower() .. "Frame"])
  -- tFrame.wndUnitFrame:MoveToLocation(tFrame.locDefaultPosition)
  self:InitColors(tFrame)

  return tFrame

end


--
-- OnCharacterLoaded
--
--
function VikingNameplates:OnCharacterLoaded()
  local playerUnit = GameLib.GetPlayerUnit()
  if not playerUnit then
    return
  end

  if VikingLib == nil then
    VikingLib = Apollo.GetAddon("VikingLibrary")
  end

  if VikingLib ~= nil then
    tDefaultSettings = {
      style = 0,
      position = {
        playerFrame = {
          fPoints  = {0.5, 1, 0.5, 1},
          nOffsets = {-350, -200, -100, -120}
        },
        targetFrame = {
          fPoints  = {0.5, 1, 0.5, 1},
          nOffsets = {100, -200, 350, -120}
        },
        focusFrame = {
          fPoints  = {0, 1, 0, 1},
          nOffsets = {40, -500, 250, -440}
        }
      },
      textStyle = {
        Value = false,
        Percent = true,
      },
      colors = {
        Health = { high = "ff" .. tColors.green,  average = "ff" .. tColors.yellow, low = "ff" .. tColors.red },
        Shield = { high = "ff" .. tColors.blue,   average = "ff" .. tColors.blue, low = "ff" ..   tColors.blue },
        Absorb = { high = "ff" .. tColors.yellow, average = "ff" .. tColors.yellow, low = "ff" .. tColors.yellow },
      }
    }

    VikingLib.Settings.RegisterSettings(self, "VikingNameplates", "Nameplates", tDefaultSettings)
    self.db = VikingLib.Settings.GetDatabase("VikingNameplates")
    self.generalDb = VikingLib.Settings.GetDatabase("General")
  end

  -- PlayerFrame
  self.tPlayerFrame = self:CreateUnitFrame("Player")

  self:SetUnit(self.tPlayerFrame, playerUnit)
  -- self:SetUnitName(self.tPlayerFrame, playerUnit:GetName())
  -- self:SetUnitLevel(self.tPlayerFrame)
  self.tPlayerFrame.wndUnitFrame:Show(true, false)
  -- self:SetClass(self.tPlayerFrame)
  self.tPlayerFrame.wndUnitFrame:SetUnit(playerUnit)

  -- Target Frame
  self.tTargetFrame = self:CreateUnitFrame("Target")
  self:UpdateUnitFrame(self.tTargetFrame, GameLib.GetTargetUnit())
  self.tTargetFrame.wndUnitFrame:SetUnit(unit)

  -- -- Focus Frame
  -- self.tFocusFrame = self:CreateUnitFrame("Focus")


  -- self.eClassID =  playerUnit:GetClassId()

end


local LoadingTimer
function VikingNameplates:OnWorldChanged()
  self:OnRequiredFlagsChanged()

  LoadingTimer = ApolloTimer.Create(0.01, true, "OnLoading", self)
end


function VikingNameplates:OnLoading()
  local playerUnit = GameLib.GetPlayerUnit()
  if not playerUnit then return end
  self:SetUnit(self.tPlayerFrame, playerUnit)
  self:SetUnitLevel(self.tPlayerFrame)
  self.tPlayerFrame.unit = playerUnit
  LoadingTimer:Stop()
end


--
-- OnTargetUnitChanged
--

function VikingNameplates:OnTargetUnitChanged(unit)
  self:UpdateUnitFrame(self.tTargetFrame, unit)
end


--
-- OnFocusUnitChanged
--

function VikingNameplates:OnFocusUnitChanged(unit)
  self:UpdateUnitFrame(self.tFocusFrame, unit)
end

function VikingNameplates:UpdateUnitFrame(tFrame, unit)
  Print("hello")

  tFrame.wndUnitFrame:Show(unit ~= nil)

  if unit ~= nil then
    self:SetUnit(tFrame, unit)
    self:SetUnitName(tFrame, unit:GetName())
    self:SetClass(tFrame)

    tFrame.id = unit:GetId()
  end

end

--
-- OnFrame
--
-- Render loop

function VikingNameplates:OnFrame()
  if not self.tPlayerFrame.unit then return end

  if self.tPlayerFrame ~= nil then

    -- UnitFrame
    self:UpdateBars(self.tPlayerFrame)

    -- TargetFrame
    self:UpdateBars(self.tTargetFrame)
    self:SetUnitLevel(self.tTargetFrame)

    -- -- FocusFrame
    -- self:UpdateBars(self.tFocusFrame)
    -- self:SetUnitLevel(self.tFocusFrame)


  end

end


--
-- UpdateBars
--
-- Update the bars for a unit on UnitFrame

function VikingNameplates:UpdateBars(tFrame)

  local tHealthMap = {
    bar     = "Health",
    current = "GetHealth",
    max     = "GetMaxHealth"
  }

  local tShieldMap = {
    bar     = "Shield",
    current = "GetShieldCapacity",
    max     = "GetShieldCapacityMax"
  }

  local tAbsorbMap = {
    bar     = "Absorb",
    current = "GetAbsorptionValue",
    max     = "GetAbsorptionMax"
  }

  self:ShowCastBar(tFrame)
  self:SetBar(tFrame, tHealthMap)
  self:SetBar(tFrame, tShieldMap)
  self:SetBar(tFrame, tAbsorbMap)
  self:SetTargetMark(tFrame)
end


-- SetBar
--
-- Set Bar Value on UnitFrame

function VikingNameplates:SetBar(tFrame, tMap)
  if tFrame.unit ~= nil and tMap ~= nil then
    local unit          = tFrame.unit
    local nCurrent      = unit[tMap.current](unit)
    local nMax          = unit[tMap.max](unit)
    local wndBar        = tFrame["wnd" .. tMap.bar .. "Bar"]
    local wndProgress   = wndBar:FindChild("ProgressBar")


    local isValidBar = (nMax ~= nil and nMax ~= 0) and true or false
    wndBar:Show(isValidBar, false)

    if isValidBar then

      wndProgress:SetMax(nMax)
      wndProgress:SetProgress(nCurrent)

      local nLowBar     = 0.3
      local nAverageBar = 0.5

      -- Set our bar color based on the percent full
      local tColors = self.db.colors[tMap.bar]
      local color   = tColors.high

      if nCurrent / nMax <= nLowBar then
        color = tColors.low
      elseif nCurrent / nMax <= nAverageBar then
        color = tColors.average
      end

      wndProgress:SetBarColor(ApolloColor.new(color))
    end
  end
end



--
-- SetClass
--
-- Set Class on UnitFrame

function VikingNameplates:SetClass(tFrame)

    local strPlayerIconSprite, strRankIconSprite, locNameText
    local sUnitType = tFrame.unit:GetType()

    if sUnitType == "Player" then
      locNameText         = { 24, 0, -30, 26 }
      strRankIconSprite   = ""
      strPlayerIconSprite = tClassToSpriteMap[tFrame.unit:GetClassId()]
    else
      locNameText         = { 34, 0, -30, 26 }
      strPlayerIconSprite = ""
      strRankIconSprite   = tRankToSpriteMap[tFrame.unit:GetRank()]
    end

    tFrame.wndUnitFrame:FindChild("TargetInfo:UnitName"):SetAnchorOffsets(locNameText[1], locNameText[2], locNameText[3], locNameText[4])
    tFrame.wndUnitFrame:FindChild("TargetInfo:ClassIcon"):SetSprite(strPlayerIconSprite)
    tFrame.wndUnitFrame:FindChild("TargetInfo:RankIcon"):SetSprite(strRankIconSprite)

end


--
-- SetDisposition
--
-- Set Disposition on UnitFrame

function VikingNameplates:SetTargetMark(tFrame)
  if not tFrame.unit then return else end

  local nMarkerID = tFrame.unit:GetTargetMarker() or 0

  if nMarkerID ~= 0 then
    local sprite = tTargetMarkSpriteMap[nMarkerID]
    tFrame.wndTargetMark:Show(true, false)
    tFrame.wndTargetMark:SetSprite(sprite)
  else
    tFrame.wndTargetMark:Show(false, true)
  end
end


--
-- SetDisposition
--
-- Set Disposition on UnitFrame

function VikingNameplates:SetDisposition(tFrame, targetUnit)
  tFrame.disposition = targetUnit:GetDispositionTo(self.tPlayerFrame.unit)
  local dispositionColor = ApolloColor.new(self.generalDb.dispositionColors[tFrame.disposition])
end


--
-- SetUnit
--
-- Set Unit on UnitFrame

function VikingNameplates:SetUnit(tFrame, unit)
  tFrame.unit = unit
  self:SetDisposition(tFrame, unit)

  -- Set the Data to the unit, for mouse events
  tFrame.wndUnitFrame:SetData(tFrame.unit)

end


--
-- SetUnitName
--
-- Set Name on UnitFrame

function VikingNameplates:SetUnitName(tFrame, sName)
  tFrame.wndUnitFrame:FindChild("UnitName"):SetText(sName)
end


--
-- SetUnitLevel
--
-- Set Level on UnitFrame

function VikingNameplates:SetUnitLevel(tFrame)
  if tFrame.unit == nil then return end
  local sLevel = tFrame.unit:GetLevel()
  tFrame.wndUnitFrame:FindChild("UnitLevel"):SetText(sLevel)
end



--
-- InitColor
--
-- Let's initialize some colors from settings

function VikingNameplates:InitColors(tFrame)

  local colors = {
    background = {
      wnd   = tFrame.wndUnitFrame:FindChild("Background"),
      color = ApolloColor.new(self.generalDb.colors.background)
    },
    gradient = {
      wnd   = tFrame.wndUnitFrame,
      color = ApolloColor.new(self.generalDb.colors.gradient)
    }
  }

  for k,v in pairs(colors) do
    v.wnd:SetBGColor(v.color)
  end
end



-- ShowCastBar
--
-- Check to see if a unit is casting, if so, render the cast bar

function VikingNameplates:ShowCastBar(tFrame)

  -- If no unit then don't do anything
  if tFrame.unit == nil then return end

  local unit = tFrame.unit
  local bCasting = unit:ShouldShowCastBar()
  self:UpdateCastBar(tFrame, bCasting)
end


--
-- UpdateCastBar
--
-- Casts that have timers use this method to indicate their progress

function VikingNameplates:UpdateCastBar(tFrame, bCasting)

  -- If just started casting
  if bCasting and tFrame.bCasting == false then
    tFrame.bCasting = true

    local wndProgressBar = tFrame.wndCastBar:FindChild("ProgressBar")
    local wndText        = tFrame.wndCastBar:FindChild("Text")
    local sCastName      = tFrame.unit:GetCastName()

    tFrame.nTimePrevious = 0
    tFrame.nTimeMax      = tFrame.unit:GetCastDuration()
    tFrame.wndCastBar:Show(true, false)
    wndProgressBar:SetProgress(0)
    wndProgressBar:SetMax(tFrame.nTimeMax)
    wndText:SetText(sCastName)

    tFrame.CastTimerTick = ApolloTimer.Create(0.01, true, "OnCast" .. tFrame.name .. "FrameTimerTick", self)

  elseif bCasting and tFrame.bCasting == true then
    return
  elseif not bCasting and tFrame.bCasting == true then
    VikingNameplates:KillCastTimer(tFrame)
    tFrame.bCasting = false
  end

end


-----------------------------------------------------------------------------------------------
-- Cast Timer
-----------------------------------------------------------------------------------------------

function VikingNameplates:OnCastPlayerFrameTimerTick()
  self:UpdateCastTimer(self.tPlayerFrame)
end


function VikingNameplates:OnCastTargetFrameTimerTick()
  self:UpdateCastTimer(self.tTargetFrame)
end

function VikingNameplates:OnCastFocusFrameTimerTick()
  self:UpdateCastTimer(self.tFocusFrame)
end

function VikingNameplates:UpdateCastTimer(tFrame)
  local wndProgressBar = tFrame.wndCastBar:FindChild("ProgressBar")
  local nMin = tFrame.unit:GetCastElapsed() or 0
  local nTimeCurrent   = math.min(nMin, tFrame.nTimeMax)
  wndProgressBar:SetProgress(nTimeCurrent, nTimeCurrent - tFrame.nTimePrevious * 1000)

  tFrame.nTimePrevious = nTimeCurrent
end


function VikingNameplates:KillCastTimer(tFrame)
  tFrame.CastTimerTick:Stop()
  local wndProgressBar = tFrame.wndCastBar:FindChild("ProgressBar")
  wndProgressBar:SetProgress(tFrame.nTimeMax)
  tFrame.wndCastBar:Show(false, .002)
end




---------------------------------------------------------------------------------------------------
-- VikingSettings Functions
---------------------------------------------------------------------------------------------------

function VikingNameplates:UpdateSettingsForm(wndContainer)
  -- Text Style
  wndContainer:FindChild("TextStyle:Content:Value"):SetCheck(self.db.textStyle["Value"])
  wndContainer:FindChild("TextStyle:Content:Percent"):SetCheck(self.db.textStyle["Percent"])

  -- Bar colors
  for strBarName, tBarColorData in pairs(self.db.colors) do
    local wndColorContainer = wndContainer:FindChild("Colors:Content:" .. strBarName)

    if wndColorContainer then
      for strColorState, strColor in pairs(tBarColorData) do
        local wndColor = wndColorContainer:FindChild(strColorState)

        if wndColor then wndColor:SetBGColor(strColor) end
      end
    end
  end
end

function VikingNameplates:OnTextStyleBtnCheck(wndHandler, wndControl, eMouseButton)
  self.db.textStyle[wndControl:GetName()] = wndControl:IsChecked()
end

function VikingNameplates:OnSettingsBarColor( wndHandler, wndControl, eMouseButton )
  VikingLib.Settings.ShowColorPickerForSetting(self.db.colors[wndControl:GetParent():GetName()], wndControl:GetName(), nil, wndControl)
end

local VikingUnitFramesInst = VikingNameplates:new()
VikingUnitFramesInst:Init()
