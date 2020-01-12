----------
-- Meta --
----------

local _, ns = ...
local libraryName = "ObeliskMathVector"
local major = 0
local minor = 1

---------------
-- Libraries --
---------------

local Vector, libVersion = ObeliskFrameworkManager:NewLibrary(libraryName, major, minor)

if not Vector then 
	if (libVersion and (libVersion.major ~= major or libVersion.minor ~= minor)) or libVersion == nil then
		error(ns.Debug:sprint(libraryName, "Failed to create library"))
	else
		return
	end
end

Vector.__index = Vector
Vector.libraryName = libraryName

setmetatable(Vector, {
	__call = function (self, ...)
		return self:New(...)
	end,
})

if ns.OBELISK_DEBUG then
	ns.Debug:print(libraryName, "LOADED")
end

---------------
-- Functions --
---------------

function Vector:New(x, y)
	self.x = x
	self.y = y
end

function Vector:ToString()
	return "(" .. self.x .. ", " .. self.y .. ")"
end







