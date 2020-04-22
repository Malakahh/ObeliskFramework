----------
-- Meta --
----------

local _, ns = ...
local libraryName = "ObeliskSliderEditBox"
local major = 0
local minor = 2

---------------
-- Libraries --
---------------

local SliderEditBox, libVersion = ObeliskFrameworkManager:NewLibrary(libraryName, major, minor)
if not SliderEditBox then
	if (libVersion and (libVersion.major ~= major or libVersion.minor ~= minor)) or libVersion == nil then
		error(ns.Debug:sprint(libraryName, "Failed to create library"))
	else
		return
	end
end

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
	instance.Slider:SetValue(1)
	instance.Slider.Text = _G[instance.Slider:GetName() .. "Text"]
	instance.Slider.LowText = _G[instance.Slider:GetName() .. "Low"]
	instance.Slider.HighText = _G[instance.Slider:GetName() .. "High"]

	instance.EditBox = CreateFrame("EditBox", nil, instance, "InputBoxTemplate")
	instance.EditBox:SetNumeric(true)
	instance.EditBox:SetAutoFocus(false)
	instance.EditBox:SetSize(30, 20)
	instance.EditBox:SetPoint("TOP", instance.Slider, "BOTTOM", 0, -5)
	instance.EditBox:SetScript("OnEnterPressed", SliderEditBox.EditBox_OnEnterPressed)
	instance.EditBox:SetScript("OnEditFocusLost", SliderEditBox.EditBox_OnEditFocusLost)

	instance.Slider.Text:SetText(text)

	return instance
end

function SliderEditBox:SetMinMaxValues(min, max)
	self.Min = tonumber(min)
	self.Max = tonumber(max)

	self.Slider:SetMinMaxValues(self.Min, self.Max)
	self.Slider.LowText:SetText(self.Min)
	self.Slider.HighText:SetText(self.Max)
end

function SliderEditBox:SetValue(value)
	self.Slider:SetValue(value)
end

function SliderEditBox:GetValue()
	return tonumber(self.EditBox:GetText())
end

function SliderEditBox:SetEnable(bool)
	self.Slider:SetEnabled(bool)
	self.EditBox:SetEnabled(bool)

	if bool then
		self.Slider.Text:SetTextColor(1,1,1,1)
		self.Slider.LowText:SetTextColor(1,1,1,1)
		self.Slider.HighText:SetTextColor(1,1,1,1)
		self.EditBox:SetTextColor(1,1,1,1)
	else
		self.Slider.Text:SetTextColor(0.3,0.3,0.3,1)
		self.Slider.LowText:SetTextColor(0.3,0.3,0.3,1)
		self.Slider.HighText:SetTextColor(0.3,0.3,0.3,1)
		self.EditBox:SetTextColor(0.3,0.3,0.3,1)
	end
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

	if val == nil then return end

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