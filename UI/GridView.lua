----------
-- Meta --
----------


local _, ns = ...
local libraryName = "ObeliskGridView"
local major = 0
local minor = 1

---------------
-- Libraries --
---------------

local GridView = ObeliskFrameworkManager:NewLibrary(libraryName, major, minor)
if not GridView then 
	error(ns.Debug:sprint(libraryName, "Failed to create library"))
end

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
	local instance = FrameworkClass(self, "Frame", name, parent)

	instance:SetSize(width, height)
	instance.items = {}
	instance:SetNumColumns(0)
	instance:SetNumRows(0)
	instance:SetTexture()

	return instance
end

function GridView:SetTexture()
	self.tex = self:CreateTexture(nil, "BACKGROUND")
	self.tex:SetAllPoints()
	self.tex:SetColorTexture(0, 1, 0, 0.5)
end

-- Sets the number of columns. 0 means auto
function GridView:SetNumColumns(num)
	self.numColumns = num
end

-- Sets the number of Rows. 0 means auto
function GridView:SetNumRows(num)
	self.numRows = num
end

function GridView:AddItem(vector, item)
	item:SetParent(self)
	item.gridPosition = vector
	self.items[item.gridPosition:ToString()] = item
	self:Update()
end

function GridView:RemoveItem(vector)
	self.items[vector] = nil
	self:Update()
end

function GridView:Update()
	local maxNumColumns, maxNumRows = self.numColumns, self.numRows
	ns.Debug:print(libraryName, tostring(self.numRows) .. " - " .. tostring(self.numColumns))
	for _,v in pairs(self.items) do
		if self.numColumns == 0 then --Should automatically generate columns
			maxNumColumns = math.max(maxNumColumns, v.gridPosition.x)
		end

		if self.numRows == 0 then -- Should automatically generate rows
			maxNumRows = math.max(maxNumRows, v.gridPosition.y)
		end
	end


	local cellWidth = self:GetWidth() / maxNumColumns
	local cellHeight = self:GetHeight() / maxNumRows

	for _,v in pairs(self.items) do
		v:SetPoint("TOPLEFT", self, "TOPLEFT", v.gridPosition.x * cellWidth, v.gridPosition.y * cellHeight)
	end
end




