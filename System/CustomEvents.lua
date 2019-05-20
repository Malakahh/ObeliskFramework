----------
-- Meta --
----------

local _, ns = ...
local libraryName = "ObeliskCustomEvents"
local major, minor = 0, 1

---------------
-- Libraries --
---------------

local CustomEvents = ObeliskFrameworkManager:NewLibrary(libraryName, major, minor)
if not CustomEvents then return end

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