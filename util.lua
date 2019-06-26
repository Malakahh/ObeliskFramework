----------
-- TODO --
----------

-- Use MergeFunc for AppendScript

local _, ns = ...

ns.Util = ns.Util or {}
ns.Util.Table = ns.Util.Table or {}

function ns.Util.AppendScript(frame, handler, func)
	local old = frame:GetScript(handler)

	if old == nil then
		frame:SetScript(handler, func)
	else
		frame:SetScript(handler, function( ... )
			old(...)
			func(...)
		end)
	end
end

function ns.Util.MergeFunc(f1, f2)
	if f1 == nil and f2 == nil then return end

	if f1 == nil and f2 then
		return f2
	end

	if f2 == nil and f1 then
		return f1
	end

	return function( ... )
		f1(...)
		f2(...)
	end
end

function ns.Util.Dump(value, depth)
	if type(value) == "nil" then return "|cFFFF00FF" .. nil .. "|r" end

	depth = depth or 0

	local str = ""

	if type(value) ~= "table" then
		return str .. " " .. tostring(value)
	else
		if depth > 0 then
			str = str .. " {|n"
		else
			str = str .. "|n"
		end

		for k,v in pairs(value) do
			for i = 1, depth do
				str = str .. "  "
			end

			str = str .. "- |cFFFF00FF" .. k .. "|r:" .. ns.Util.Dump(v, depth + 1) .. ",|n"
		end

		if depth > 0 then
			str = str .. "}"
		end
	end

	if depth == 0 then
		print(str)
	else
		return str
	end
end

-------------
--- Table ---
-------------

function ns.Util.Table.Copy(source, dest, force)
	if not source then return end

	force = force or false
	dest = dest or {}

    for k,v in pairs(source) do
    	if dest[k] == nil or force then
    		if type(v) == "table" then
    			dest[k] = ns.Util.Table.Copy(v)
    		else
    			dest[k] = v
    		end
    	end
    end

    return dest
end

function ns.Util.Table.IndexWhere(t, funcCondition, ...)
	for k,v in pairs(t) do
		if funcCondition(k, v, ...) then
			return k
		end
	end

	return nil
end

local function FuncIndexOf(k, v, val)
	return v == val
end
function ns.Util.Table.IndexOf(t, val)
	return ns.Util.Table.IndexWhere(t, FuncIndexOf, val)
end

function ns.Util.Table.RemoveByVal(t, val)
	local i = ns.Util.Table.IndexOf(t, val)
	if i ~= nil then
		table.remove(t, i)
		return true
	end

	return false;
end

function ns.Util.Table.Arrange(t)
	local ret = {}
	for _,v in pairs(t) do
		table.insert(ret, v)
	end

	return ret
end
