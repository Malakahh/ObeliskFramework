----------
-- Meta --
----------

local _, ns = ...
local libraryName = "ObeliskVersionUnification"
local major, minor = 0, 1

---------------
-- Libraries --
---------------

local VersionUnification, libVersion = ObeliskFrameworkManager:NewLibrary(libraryName, major, minor)
if not VersionUnification then 
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

VersionUnification.libraryName = libraryName

------------
-- Locals --
------------


-----------
-- Class --
-----------

VersionUnification.IsRetail = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE)
VersionUnification.IsClassic = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)
VersionUnification.IsTBC = (WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC)