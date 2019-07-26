----------
-- Meta --
----------

local _, ns = ...
local libraryName = "ObeliskSliderEditBox"
local major = 0
local minor = 1

---------------
-- Libraries --
---------------

local SliderEditBox = ObeliskFrameworkManager:NewLibrary(libraryName, major, minor)
if not SliderEditBox then return end

local FrameworkClass = ObeliskFrameworkManager:GetLibrary("ObeliskFrameworkClass", 1)
if not FrameworkClass then
	error(ns.Debug:sprint(libraryName, "Failed to load ObeliskFrameworkClass"))
end

if ns.OBELISK_DEBUG then
	ns.Debug:print(libraryName, "LOADED")
end

SliderEditBox.libraryName = libraryName

setmetatable(SliderEditBox, {
	__call = function (self, ...)
		return self:New(...)
	end
})

---------------
-- Functions --
---------------

function SliderEditBox:New(frameName, parent, text, OnValueChangedCallback)
	local instance = FrameworkClass({
		prototype = self,
		frameType = "FRAME",
		frameName = frameName,
		parent = parent or UIParent,
	})	

	instance.OnValueChangedCallback = OnValueChangedCallback

	instance.Slider = CreateFrame("Slider", instance:GetName() .. "_Slider", instance, "OptionsSliderTemplate")
	instance.Slider:SetOrientation("HORIZONTAL")
	instance.Slider:SetPoint("TOPLEFT", instance, "TOPLEFT", 0, 0)
	instance.Slider:SetPoint("TOPRIGHT", instance, "TOPRIGHT", 0, 0)
	instance.Slider:SetHeight(20)
	instance.Slider:SetObeyStepOnDrag(true)
	instance.Slider:SetValueStep(1)
	instance.Slider:SetScript("OnValueChanged", instance.Slider_OnValueChanged)

	instance.EditBox = CreateFrame("EditBox", nil, instance, "InputBoxTemplate")
	instance.EditBox:SetNumeric(true)
	instance.EditBox:SetAutoFocus(false)
	instance.EditBox:SetSize(30, 20)
	instance.EditBox:SetPoint("TOP", instance.Slider, "BOTTOM", 0, 0)
	instance.EditBox:SetScript("OnEnterPressed", SliderEditBox.EditBox_OnEnterPressed)
	instance.EditBox:SetScript("OnEditFocusLost", SliderEditBox.EditBox_OnEditFocusLost)

	instance.Slider:SetValue(1)

	_G[instance.Slider:GetName() .. "Text"]:SetText(text)

	return instance
end

function SliderEditBox:SetMinMaxValues(min, max)
	self.Min = tonumber(min)
	self.Max = tonumber(max)

	self.Slider:SetMinMaxValues(self.Min, self.Max)
	_G[self.Slider:GetName() .. "Low"]:SetText(self.Min)
	_G[self.Slider:GetName() .. "High"]:SetText(self.Max)
end

function SliderEditBox:SetValue(value)
	self.Slider:SetValue(value)
end

function SliderEditBox:GetValue()
	return tonumber(self.EditBox:GetText())
end

function SliderEditBox.Slider_OnValueChanged(self, value)
	local parent = self:GetParent()
	parent.EditBox:SetText(value)

	if parent.OnValueChangedCallback ~= nil then
		parent.OnValueChangedCallback(parent, value)
	end
end

function SliderEditBox.EditBox_OnEnterPressed(self)
	local parent = self:GetParent()
	local val = tonumber(self:GetText())

	if val < parent.Min then
		val = parent.Min
	elseif val > parent.Max then
		val = parent.Max
	end

	self:SetText(val)
	parent.Slider:SetValue(val)
	
	if parent.OnValueChangedCallback ~= nil then
		parent.OnValueChangedCallback(parent, val)
	end
end

function SliderEditBox.EditBox_OnEditFocusLost(self)
	self:GetParent().EditBox_OnEnterPressed(self)
end