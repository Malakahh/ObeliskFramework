local addonName, ns = ...

local managerName = "ObeliskFrameworkManager"
local managerVersion = 2
local Manager = _G[managerName]

if ns.OBELISK_DEBUG then
	ns.Debug:print(managerName, "LOADED")
end

--Check to see if this manager is obsolete
if not Manager or Manager.version < managerVersion then
	Manager = Manager or { libs = {} }
	_G[managerName] = Manager
	Manager.version = managerVersion

	function Manager:NewLibrary(library, major, minor)
		assert(type(library) == "string", "Bad argument 'library', string expected")
		assert(type(major) == "number", "Bad argument 'major', number expected")
		assert(type(minor) == "number", "Bad argument 'minor', number expected")

		if ns.OBELISK_DEBUG then
			ns.Debug:print(managerName, "Adding: " .. library .. " v" .. major .. "." .. minor)
		end

		self.libs[library] = self.libs[library] or {}

		local libMajor = self.libs[library][major]
		
		if libMajor and libMajor.version.minor >= minor then return nil, libMajor.version end
		self.libs[library][major] = {}
		self.libs[library][major].version = {
			major = major,
			minor = minor
		}

		return self.libs[library][major]
	end

	function Manager:GetLibrary(library, major)
		if not self.libs[library] or not self.libs[library][major] then
			error("Cannot find a library instance of " .. library .. " version: " .. major)
		end

		return self.libs[library][major]
	end

	function Manager:GetLibraryIterator()
		return pairs(self.libs)
	end
end