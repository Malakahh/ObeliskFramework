----------
-- Meta --
----------

local _, ns = ...
local libraryName = "ObeliskFrameworkClass"
local major, minor = 1, 0

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
ns.OBELISK_PROPERTY_GET_PREFIX = propertyPrefix .. "get"
ns.OBELISK_PROPERTY_SET_PREFIX = propertyPrefix .. "set"

---------------
-- Functions --
---------------

-- Arguments:
-- config table of the format below

-- local ClassConfigTable = {
-- 	prototype = {}, 			--	[table] 	A table containing methods of the class, can be nil
-- 	frameType = "", 			--	[string] 	Type of frame, i.e "FRAME", "BUTTON", etc.
-- 	frameName = "", 			--	[string] 	Global name of frame
-- 	parent = {}, 				--	[table] 	Parent frame, defaults to UIParent
-- 	inheritsFrame = "",			--	[string]	Frame that this new frame inherits
-- }
function FrameworkClass:New(config)
	assert(config.prototype == nil or type(config.prototype) == "table", "Bad argument 'prototype', table or nil expected")
	assert(config.frameType == nil or type(config.frameType) == "string", "Bad argument 'frameType', string or nil expected")
	assert(config.frameName == nil or type(config.frameName) == "string", "Bad argument 'frameName', string or nil expected")
	assert(config.parent == nil or type(config.parent) == "table", "Bad argument 'parent', table or nil expected")
	assert(config.inheritsFrame == nil or type(config.inheritsFrame) == "string", "Bad argument 'inheritsFrame', string or nil expected")
	assert(config.modifyMetaTable == nil or type(config.modifyMetaTable) == "boolean", "Bad argument 'modifyMetaTable', boolean or nil expected")

	local instance

	if config.frameType then
		instance = CreateFrame(config.frameType, config.frameName, config.parent or UIParent, config.inheritsFrame)
	else
		instance = {}
	end

	if config.prototype ~= nil then
		ns.Util.Table.Copy(config.prototype, instance)
		instance["__oldMetaTable"] = getmetatable(instance)

		setmetatable(instance, {
			__index = function(self, key)
				-- If it exists as a property
				if type(key) == "string" and rawget(self, propertyPrefix .. key) ~= nil and rawget(self, ns.OBELISK_PROPERTY_GET_PREFIX .. key) then
					return rawget(self, ns.OBELISK_PROPERTY_GET_PREFIX .. key)(self, propertyPrefix .. key)
				end

				-- If it exists and is not a property
				if rawget(self, key) ~= nil then
					return rawget(self, key)
				end

				-- If it exists in metatable
				if rawget(instance, "__oldMetaTable")["__index"][key] ~= nil then
					return rawget(instance, "__oldMetaTable")["__index"][key]
				else -- Nothing to be found
					return nil
				end
			end,
			__newindex = function(self, key, value)
				-- If it exists as a property
				if type(key) == "string" and rawget(self, ns.OBELISK_PROPERTY_SET_PREFIX .. key) ~= nil then
					rawset(self, propertyPrefix .. key, rawget(self, ns.OBELISK_PROPERTY_SET_PREFIX .. key)(self, propertyPrefix .. key, value))
					--self[propertyPrefix .. key] = self[ns.OBELISK_PROPERTY_SET_PREFIX .. key](self, propertyPrefix .. key, value)
					return
				end

				--self[key] = value
				rawset(self, key, value)
			end
		})


		
	end

	return instance
end







