----------
-- Meta --
----------

local _, ns = ...
local libraryName = "ObeliskFrameworkClass"
local major, minor = 0, 2

---------------
-- Libraries --
---------------

local FrameworkClass = ObeliskFrameworkManager:NewLibrary(libraryName, major, minor)
if not FrameworkClass then return end

if ns.OBELISK_DEBUG then
	ns.Debug:print(libraryName, "LOADED")
end

setmetatable(FrameworkClass, {
	__call = function (self, ...)
		return self:New(...)
	end,
	__index = FrameworkClass
})

---------------
-- Constants --
---------------

local propertyPrefix = "__"
local propertyGetterPrefix = propertyPrefix .. "get"
local propertySetterPrefix = propertyPrefix .. "set"

---------------
-- Functions --
---------------

-- Arguments
-- <table> prototype:		A table containing methods of the class, can be nil
-- <string> frameType:		Type of frame, i.e "Frame", "Button", etc.
-- <string> frameName:		Global name of frame
-- <frame> parent:			Parent frame, defaults to UIParent
-- <string> inheritsFrame:	Frame that this new frame inherits
function FrameworkClass:New(prototype, frameType, frameName, parent, inheritsFrame)
	assert(prototype == nil or type(prototype) == "table", "Bad argument 'prototype', table or nil expected")

	local instance

	if frameType then
		instance = CreateFrame(frameType, frameName, parent or UIParent, inheritsFrame)
	else
		instance = {}
	end

	if prototype ~= nil then
		ns.Util.Table.Copy(prototype, instance)

		setmetatable(instance, {
			__call = function (self, ...)
				return self:New(...)
			end,
			__index = function(self, key)
				-- If it exists as a property
				if typeof(key) == "string" and self[propertyPrefix .. key] ~= nil and self[propertyGetterPrefix .. key] then
					return self[propertyGetterPrefix .. key](self, key)
				end

				-- If it exists and is not a property
				if self[key] ~= nil then
					return self[key]
				end

				-- If it exists in metatable
				if instance[key] ~= nil then
					return instance[key]
				else -- Nothing to be found
					return nil
				end
			end,
			__newindex = function(self, key, value)
				-- If it exists as a property
				if typeof(key) == "string" and self[propertySetterPrefix .. key] ~= nil then
					self[propertySetterPrefix .. key](self, key, value)
					return
				end

				self[key] = value
			end
		})
	end

	return instance
end







