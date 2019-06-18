----------
-- Meta --
----------

local _, ns = ...
local libraryName = "ObeliskCollectionsStack"
local major = 0
local minor = 2

---------------
-- Libraries --
---------------

local Stack = ObeliskFrameworkManager:NewLibrary(libraryName, major, minor)
if not Stack then return end

Stack.libraryName = libraryName

setmetatable(Stack, {
	__call = function (self, ...)
		return self:New(...)
	end
})

local FrameworkClass = ObeliskFrameworkManager:GetLibrary("ObeliskFrameworkClass", 1)
if not FrameworkClass then
	error(ns.Debug:sprint(libraryName, "Failed to load ObeliskFrameworkClass"))
end

if ns.OBELISK_DEBUG then
	ns.Debug:print(libraryName, "LOADED")
end

------------
-- Locals --
------------

local shouldSetMetaTable = true

---------------
-- Functions --
---------------

function Stack:New()
	local instance = FrameworkClass({
		prototype = self,
		frameName = "Stack"
	})
	shouldSetMetaTable = false

	instance.items = {}

	return instance
end

function Stack:Push( ... )
	if ... then
		local targs = {...}
		for _,v in ipairs(targs) do
			table.insert(self.items, v)
		end
	end
end

function Stack:Pop()
	return table.remove(self.items)
end

function Stack:Count()
	return #self.items
end







