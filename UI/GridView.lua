----------
-- Meta --
----------

local _, ns = ...
local libraryName = "ObeliskGridView"
local major = 1
local minor = 3

---------------
-- Libraries --
---------------

local GridView, libVersion = ObeliskFrameworkManager:NewLibrary(libraryName, major, minor)
if not GridView then
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

GridView.libraryName = libraryName

setmetatable(GridView, {
	__call = function (self, ...)
		return self:New(...)
	end
})

---------------
-- Functions --
---------------

function GridView:New(width, height, name, parent)
	local instance = FrameworkClass({
		prototype = self,
		frameType = "FRAME",
		frameName = name,
		parent = parent or UIParent,
	})	

	instance:SetSize(width, height)
	instance.items = {}
	instance:SetNumColumns(0)
	instance:SetNumRows(0)
	instance:SetCellMargin() -- 0, 0

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
	local res = ns.Util.Table.RemoveByVal(self.items, item)
end

function GridView:ItemCount()
	return #self.items
end

function GridView:SetCellMargin(horizontal, vertical)
	self.HorizontalCellMargin = horizontal or 0
	self.VerticalCellMargin = vertical or 0
end

function GridView:GetCalculatedGridSize()
	local calculatedWidth = nil
	local calculatedHeight = nil

	if self.cellWidth ~= nil then
		local numColumns = self.numColumns

		if (numColumns == nil or numColumns == 0) and (self.numRows ~= nil or self.numRows ~= 0) then
			numColumns = math.ceil(self:ItemCount() / self.numRows)
		end

		if numColumns == nil or numColumns == 0 then
			numColumns = 1
		end

		if numColumns ~= nil then
			calculatedWidth = numColumns * self.cellWidth

			if self.HorizontalCellMargin ~= nil and self.HorizontalCellMargin ~= 0 then
				calculatedWidth = calculatedWidth + numColumns * self.HorizontalCellMargin
			end
		end
	end

	if self.cellHeight ~= nil then
		local numRows = self.numRows

		if (numRows == nil or numRows == 0) and (self.numColumns ~= nil or self.numColumns ~= 0) then
			numRows = math.ceil(self:ItemCount() / self.numColumns)
		end

		if numRows == nil or numRows == 0 then
			numRows = 1
		end

		if numRows ~= nil then
			calculatedHeight = numRows * self.cellHeight

			if self.VerticalCellMargin ~= nil and self.VerticalCellMargin ~= 0 then
				calculatedHeight = calculatedHeight + numRows * self.VerticalCellMargin
			end
		end
	end

	if calculatedWidth == 0 then
		calculatedWidth = nil
	end

	if calculatedHeight == 0 then
		calculatedHeight = nil
	end

	return calculatedWidth, calculatedHeight
end

function GridView:Sort(compFunc)
	table.sort(self.items, compFunc)
end

function GridView:Update()
	local maxNumColumns, maxNumRows = self.numColumns, self.numRows

	if maxNumColumns == 0 then --Should automatically generate columns
		maxNumColumns = math.ceil(self:GetWidth() / (self.cellWidth + self.HorizontalCellMargin))

		if maxNumColumns == 0 then --If it's still 0, define it as 1
			maxNumColumns = 1
		end
	end

	if maxNumRows == 0 then -- Should automatically generate rows
		maxNumRows = math.ceil(self:GetHeight() / (self.cellHeight + self.VerticalCellMargin))

		if maxNumRows == 0 then --If it's still 0, define it as 1
			maxNumRows = 1
		end
	end

	if #self.items == 0 then
		return
	end

	local i = 1
	for y = 0, maxNumRows - 1 do
		for x = 0, maxNumColumns - 1 do
			local item = self.items[i]
			item:ClearAllPoints()
			item:SetPoint("TOPLEFT", self, "TOPLEFT", x * self.cellWidth + x * self.HorizontalCellMargin, -y * self.cellHeight - y * self.VerticalCellMargin)

			if self.debug then
				self:ItemDebug(item)
			end

			i = i + 1

			if i > #self.items then
				return
			end
		end
	end
end

function GridView:ItemDebug(item)
	if self.debug == nil then
		return
	end

	if self.debug then

		-- if item.ObeliskFramework_GridView_ItemDebugTexture == nil then
		-- 	local tex = item:CreateTexture(nil, "HIGHLIGHT")
		-- 	--tex:SetSize(item:GetWidth(), item:GetHeight())
		-- 	tex:SetColorTexture(0, 1, 0, 0.5)
		-- 	tex:SetAllPoints(item)
		-- 	item.ObeliskFramework_GridView_ItemDebugTexture = tex
		-- end

		-- item.ObeliskFramework_GridView_ItemDebugTexture:Show()

		if item.ObeliskFramework_GridView_ItemDebugString == nil then
			local str = item:CreateFontString(nil, "OVERLAY", "GameFontNormalTiny2")
			str:SetPoint("TOPLEFT", item, "TOPLEFT")

			item.ObeliskFramework_GridView_ItemDebugString = str
		end

		item.ObeliskFramework_GridView_ItemDebugString:SetText(item:GetDebugText())
		item.ObeliskFramework_GridView_ItemDebugString:Show()

		-- instance.Title = instance:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
		-- instance.Title:SetPoint("TOPLEFT", instance.padding, -instance.padding)
		-- instance.Title:SetText("Title")


	else
		-- item.ObeliskFramework_GridView_ItemDebugTexture:Hide()
		item.ObeliskFramework_GridView_ItemDebugString:Hide()
	end
end

function GridView:ToggleDebug()
	if self.debug == nil then
		self.debug = false
	end

	self.debug = not self.debug
	self:Update()
end