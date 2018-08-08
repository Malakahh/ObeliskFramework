----------
-- Meta --
----------


local _, ns = ...
local libraryName = "ObeliskGridView"
local major = 1
local minor = 0

---------------
-- Libraries --
---------------

local GridView = ObeliskFrameworkManager:NewLibrary(libraryName, major, minor)
if not GridView then return end

local FrameworkClass = ObeliskFrameworkManager:GetLibrary("ObeliskFrameworkClass", 0)
if not FrameworkClass then
	error(ns.Debug:sprint(libraryName, "Failed to load ObeliskFrameworkClass"))
end

if ns.OBELISK_DEBUG then
	ns.Debug:print(libraryName, "LOADED")
end

GridView.libraryName = libraryName

setmetatable(GridView, {
	__call = function (self, ...)
		return self:New(...)
	end,
	__index = GridView
})

---------------
-- Functions --
---------------

function GridView:New(width, height, name, parent)
	local instance = FrameworkClass(self, "FRAME", name, parent)

	instance:SetSize(width, height)
	instance.items = {}
	instance:SetNumColumns(0)
	instance:SetNumRows(0)

	return instance
end

-- Sets the number of columns. 0 means auto
function GridView:SetNumColumns(num)
	assert(num >= 0)
	self.numColumns = num
end

function GridView:GetNumColumns()
	return self.numColumns
end

-- Sets the number of Rows. 0 means auto
function GridView:SetNumRows(num)
	assert(num >= 0)
	self.numRows = num
end

function GridView:GetNumRows()
	return self.numRows
end

function GridView:SetCellWidth(width)
	self.cellWidth = width
end

function GridView:SetCellHeight(height)
	self.cellHeight = height
end

function GridView:SetCellSize(width, height)
	self:SetCellWidth(width)
	self:SetCellHeight(height)
end

function GridView:AddItem(item)
	item:SetParent(self)
	table.insert(self.items, item)
end

function GridView:RemoveItem(item)
	table.remove(item)
end

function GridView:ItemCount()
	return #self.items
end

function GridView:Update()
	local maxNumColumns, maxNumRows = self.numColumns, self.numRows

	if maxNumColumns == 0 then --Should automatically generate columns
		maxNumColumns = math.floor(self:GetWidth() / self.cellWidth)

		if maxNumColumns == 0 then --If it's still 0, define it as 1
			maxNumColumns = 1
		end
	end

	if maxNumRows == 0 then -- Should automatically generate rows
		maxNumRows = math.floor(self:GetHeight() / self.cellHeight)

		if maxNumRows == 0 then --If it's still 0, define it as 1
			maxNumRows = 1
		end
	end

	local i = 1
	for y = 0, maxNumRows - 1 do
		for x = 0, maxNumColumns - 1 do
			local item = self.items[i]
			item:ClearAllPoints()
			item:SetPoint("TOPLEFT", self, "TOPLEFT", x * self.cellWidth, -y * self.cellHeight)
			i = i + 1

			if i > #self.items then
				return
			end
		end
	end
end
