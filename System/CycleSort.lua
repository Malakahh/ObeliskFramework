----------
-- Meta --
----------

local _, ns = ...
local libraryName = "ObeliskCycleSort"
local major, minor = 0, 1

---------------
-- Libraries --
---------------

local CycleSort = ObeliskFrameworkManager:NewLibrary(libraryName, major, minor)
if not CycleSort then return end

------------
-- Locals --
------------

local frame = CreateFrame("FRAME")
function frame:OnUpdate(elapsed)
	local alive = coroutine.resume(CycleSort.coroutine)
	if not alive then
		self:SetScript("OnUpdate", nil)
	end
end

---------------
-- Functions --
---------------

-- Sorting algorithm that performs a theoretical optimal number of writes
-- See https://en.wikipedia.org/wiki/Cycle_sort
-- Parameters:
-- - array: The array to Sort
-- - funcTable: A table containing a number of functions for use by the algorithm, see below for details
--
-- funcTable Details:
-- - Compare(arr, val1, val2), compares the two values. val1 and val2 are indexes in the array. If arr[val1] < arr[val2] it returns -1. If arr[val1] > arr[val2] it returns 1. if arr[val1] == arr[val2] it returns 0.
-- - Swap(arr, val1, val2), val1 and val2 are indexes in the array. Swaps arr[val1] and arr[val2]
function CycleSort.Sort(array, funcTable)
	if CycleSort.coroutine ~= nil then
		local status = coroutine.status(CycleSort.coroutine)
		if status ~= "dead" then
			error(ns.Debug:sprint(libraryName, "Attempted to start one sort, while another has yet to completed. Status of other: " .. status))
		end
	end

	CycleSort.coroutine = coroutine.create(CycleSort.Process)
	CycleSort.array = array
	CycleSort.funcTable = funcTable
	frame:SetScript("OnUpdate", frame.OnUpdate)
end

-- Selection sort, for verification purposes
-- function CycleSort.Process()
-- 	for i = 1, #CycleSort.array - 1 do
-- 		local jMin = i
-- 		for j = i + 1, #CycleSort.array do
-- 			if CycleSort.funcTable.Compare(CycleSort.array, j, jMin) == -1 then
-- 				jMin = j
-- 			end
-- 		end

-- 		if jMin ~= i then
-- 			CycleSort.funcTable.Swap(CycleSort.array, i, jMin)
-- 			coroutine.yield()
-- 		end
-- 	end
-- end

-- Intended to be called internally
function CycleSort.Process()
	for cycleStart = 1, #CycleSort.array do
		local itemIdx = cycleStart
		
		-- Find where to put the item
		local pos = cycleStart
		for i = cycleStart + 1, #CycleSort.array do
			if CycleSort.funcTable.Compare(CycleSort.array, i, itemIdx) == -1 then -- array[i] < item
				pos = pos + 1
			end
		end

		-- If the item isn't in its correct place, put the item there or right after any duplicates
		if pos ~= cycleStart then

			-- Skip any potential duplicates
			if itemIdx ~= pos then
				while CycleSort.funcTable.Compare(CycleSort.array, itemIdx, pos) == 0 do
				 	pos = pos + 1
				end
			end

			-- Swap
			CycleSort.funcTable.Swap(CycleSort.array, itemIdx, pos)
			coroutine.yield()		

			-- Rotate the rest of the cycle
			while pos ~= cycleStart do
				--print("Pos: " .. pos .. " cycleStart: " .. cycleStart)

				-- Find where to put the item
				pos = cycleStart
				for k = cycleStart + 1, #CycleSort.array do
					if CycleSort.funcTable.Compare(CycleSort.array, k, itemIdx) == -1 then -- array[i] < item
						pos = pos + 1
					end
				end

				-- Put the item there, or right after any duplicates
				if itemIdx ~= pos then
					while CycleSort.funcTable.Compare(CycleSort.array, itemIdx, pos) == 0 do
						print ("Incrementing: itemIdx: " .. itemIdx .. " pos: " .. pos)
						pos = pos + 1
					end
				end
					
				CycleSort.funcTable.Swap(CycleSort.array, itemIdx, pos)
				coroutine.yield()
			end
		end
	end

	-- print("Finish")
	-- do
	-- 	local s = ""
	-- 	for k,v in pairs(CycleSort.array) do
	-- 		s = s .. " " .. k .. ":".. v.virt
	-- 	end
	-- 	print(s)
	-- end
end