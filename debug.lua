local addonName, ns = ...

ns.Debug = {}

function ns.Debug:tostring(msg)
	local t = type(msg)
	if t == "nil" then
		return tostring(msg)
	elseif t == "bool" then
		return tostring(msg)
	elseif t == "number" then
		return tostring(msg)
	elseif t == "string" then
		return msg
	elseif t == "table" then
		return type(msg)
	else
		error("Type of 'msg': " .. type(msg) .. " not currently supported")
	end
end

function ns.Debug:sprint(libraryName, msg)
	assert(type(self) == "table", "Argument 'self' expected type table")
	assert(type(libraryName) == "string", "Argument 'libraryName' expected type string")

	local str = self:tostring(msg)
	return addonName .. ", " .. libraryName .. ": " .. str
end

function ns.Debug:print(libraryName, msg)
	print(ns.Debug:sprint(libraryName, msg))
end