----------
-- Meta --
----------

local _, ns = ...
local libraryName = "ObeliskOptions"
local major, minor = 0, 2

---------------
-- Libraries --
---------------

local Options = ObeliskFrameworkManager:NewLibrary(libraryName, major, minor)
if not Options then return end

local FrameworkClass = ObeliskFrameworkManager:GetLibrary("ObeliskFrameworkClass", 1)
if not FrameworkClass then
	error(ns.Debug:sprint(libraryName, "Failed to load ObeliskFrameworkClass"))
end

if ns.OBELISK_DEBUG then
	ns.Debug:print(libraryName, "LOADED")
end

Options.libraryName = libraryName

-- setmetatable(Options, {
-- 	__call = function (self, ...)
-- 		return self:New(...)
-- 	end,
-- 	__index = Options
-- })

---------------
-- Functions --
---------------

function Options:New(name, parent, onRefresh, onOkay, onCancel, onDefault)
	local instance = FrameworkClass({
		prototype = self,
		frameType = "FRAME",
	})	

	instance.name = name
	instance.parent = parent
	instance.refresh = onRefresh
	instance.okay = ns.Util.MergeFunc(onOkay, self.CallOkay)
	instance.cancel = onCancel
	instance.default = onDefault

	InterfaceOptions_AddCategory(instance)

	return instance
end

function Options:RegisterForOkay(func, ...)
	self.okayCallbacks = self.okayCallbacks or {}
	table.insert(self.okayCallbacks, {
		callback = func,
		args = {...}
	})
end

function Options:CallOkay()
	if self.okayCallbacks then
		for _,v in pairs(self.okayCallbacks) do
			v.callback(unpack(v.args))
		end
	end
end