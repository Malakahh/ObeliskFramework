----------
-- Meta --
----------

local _, ns = ...
local libraryName = "ObeliskCollapsePanel"
local major, minor = 0, 1

---------------
-- Libraries --
---------------

local CollapsePanel, libVersion = ObeliskFrameworkManager:NewLibrary(libraryName, major, minor)
if not CollapsePanel then
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

CollapsePanel.libraryName = libraryName

setmetatable(CollapsePanel, {
	__call = function (self, ...)
		return self:New(...)
	end
})

---------------
-- Functions --
---------------

function CollapsePanel:New(frameName, parent, width, height)
	local instance = FrameworkClass({
		prototype = self,
		frameType = "FRAME",
		frameName = frameName,
		parent = parent or UIParent,
	})

	instance.Width = width
	instance.Height = height

	instance:Open()

	return instance
end

CollapsePanel[FrameworkClass.PROPERTY_GET_PREFIX .. "Width"] = function(self, key)
	return self._width
end

CollapsePanel[FrameworkClass.PROPERTY_SET_PREFIX .. "Width"] = function(self, key, value)
	self._width = value
	return value
end

CollapsePanel[FrameworkClass.PROPERTY_GET_PREFIX .. "Height"] = function(self, key)
	return self._height
end

CollapsePanel[FrameworkClass.PROPERTY_SET_PREFIX .. "Height"] = function(self, key, value)
	self._height = value
	return value
end

function CollapsePanel:Open()
	self:SetSize(self.Width, self.Height)
	self:Show()
	self.IsCollapsed = false
end

function CollapsePanel:Close()
	self:SetSize(1, 1) -- unable to set to 0,0 for some reason, but would be preferable
	self:Hide()
	self.IsCollapsed = true
end

function CollapsePanel:Toggle()
	if self.IsCollapsed then
		self:Open()
	else
		self:Close()
	end
end