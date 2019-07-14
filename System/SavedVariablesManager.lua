----------
-- TODO --
----------

-- Versioning for data upon init, to support migrations in the future


----------
-- Meta --
----------

local _, ns = ...
local libraryName = "ObeliskSavedVariablesManager"
local major, minor = 0, 2

---------------
-- Libraries --
---------------

local SavedVariablesManager = ObeliskFrameworkManager:NewLibrary(libraryName, major, minor)
if not SavedVariablesManager then 
	error(ns.Debug:sprint(libraryName, "Failed to create library"))
end

local FrameworkClass = ObeliskFrameworkManager:GetLibrary("ObeliskFrameworkClass", 1)
if not FrameworkClass then
	error(ns.Debug:sprint(libraryName, "Failed to load ObeliskFrameworkClass"))
end

if ns.OBELISK_DEBUG then
	ns.Debug:print(libraryName, "LOADED")
end

SavedVariablesManager.libraryName = libraryName

------------
-- Locals --
------------

local singleton = nil
local characterName
local realmName

local function FlipTables(source, dest, tableKey)
	if tableKey then
		if source[realmName] == nil then
			return
		elseif source[realmName][characterName] == nil then
			return
		elseif source[realmName][characterName][tableKey] == nil then
			return
		end

		table.wipe(dest[realmName][characterName][tableKey])
		ns.Util.Table.Copy(source[realmName][characterName][tableKey], dest[realmName][characterName][tableKey], true)
	else
		table.wipe(dest)
		ns.Util.Table.Copy(source, dest, true)
	end
end

-----------
-- Class --
-----------

function SavedVariablesManager.Init(SavedVariables)
	singleton = FrameworkClass({
		prototype = self,
		frameType = nil,
		frameName = nil,
		parent = nil,
		inheritsFrame = nil
	})

	characterName, realmName = UnitFullName("player")

	singleton.__SavedVariables = SavedVariables
	singleton.__WorkingTable = {}
	singleton.__Default = {}
	SavedVariablesManager.Reset() -- Creates our working table
	SavedVariablesManager.SetAsDefault()
end

function SavedVariablesManager.CreateRegisteredTable(tableKey)
	if singleton.__WorkingTable[realmName] then
		if singleton.__WorkingTable[realmName][characterName] then
			if singleton.__WorkingTable[realmName][characterName][tableKey] then
				return singleton.__WorkingTable[realmName][characterName][tableKey]
			end
		end
	end

	singleton.__WorkingTable[realmName] = {}
	singleton.__WorkingTable[realmName][characterName] = {}
	singleton.__WorkingTable[realmName][characterName][tableKey] = {}

	SavedVariablesManager.Reset(tableKey)
	return singleton.__WorkingTable[realmName][characterName][tableKey]
end

function SavedVariablesManager.GetRegisteredTable(tableKey)
	return singleton.__WorkingTable[realmName][characterName][tableKey]
end

function SavedVariablesManager.Reset(tableKey)
	FlipTables(singleton.__SavedVariables, singleton.__WorkingTable, tableKey)
end

function SavedVariablesManager.Save(tableKey)
	FlipTables(singleton.__WorkingTable, singleton.__SavedVariables, tableKey)
end

function SavedVariablesManager.SetAsDefault(tableKey)
	FlipTables(singleton.__SavedVariables, singleton.__Default, tableKey)
end

function SavedVariablesManager.ResetToDefault(tableKey)
	FlipTables(singleton.__Default, singleton.__SavedVariables, tableKey)
	FlipTables(singleton.__Default, singleton.__WorkingTable, tableKey)
end