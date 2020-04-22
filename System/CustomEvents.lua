----------
-- Meta --
----------

local _, ns = ...
local libraryName = "ObeliskCustomEvents"
local major, minor = 0, 1

---------------
-- Libraries --
---------------

local CustomEvents, libVersion = ObeliskFrameworkManager:NewLibrary(libraryName, major, minor)
if not CustomEvents then
	if (libVersion and (libVersion.major ~= major or libVersion.minor ~= minor)) or libVersion == nil then
		error(ns.Debug:sprint(libraryName, "Failed to create library"))
	else
		return
	end
end

function CustomEvents:Register(eventName, func)
	if self.registeredEvents == nil then
		self.registeredEvents = {}
	end

	if self.registeredEvents[eventName] == nil then
		self.registeredEvents[eventName] = {}
	end

	table.insert(self.registeredEvents[eventName], func)
end

function CustomEvents:Fire(eventName, args)
	if self.registeredEvents == nil then
		return
	end

	if self.registeredEvents[eventName] == nil then
		return
	end

	for _, v in pairs(self.registeredEvents[eventName]) do
		v(args)
	end
end