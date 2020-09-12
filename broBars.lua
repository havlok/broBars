print("broBars v4.0 Loaded.  Retail 2: Electric Boogaloo!")

-- start main loop
for i, v in ipairs(characterList) do
	--	print(v) --debug to list all players in characterList
	local healthBar = characterList[i]
	local powerBar = characterList[i]
	local function sn(h) --formats HP/MP to smaller values i.e. 1000 to 1k
	  if h > 999999 then
	    return format("%.1fm", h / 1000000)
	  elseif h > 999 then
	    return format("%.1fk", h / 1000)
	  else
	    return format("%d", h)
	  end
	end

	-- create bar frames
	local healthBar = CreateFrame("StatusBar")  --  HP Bar
	healthBar:SetWidth(barWidth)
	healthBar:SetHeight(barHeight)
	healthBar:SetPoint("CENTER", UIParent, "CENTER", hPosition, vPosition + (i * barOffset))
	healthBar:SetOrientation(fillOrientation)
	healthBar:SetStatusBarTexture(barTexture)
	healthBar:SetBackdrop({
			bgFile=barTexture, 
			insets={left=barBorder, right=barBorder, top=barBorder, bottom=barBorder}});
	healthBar:SetBackdropColor(0, 0, 0, 1)
	healthBar:SetRotatesTexture(false)

	-- sets up events for updating HP bar frames
	healthBar:RegisterEvent("ADDON_LOADED")
	healthBar:RegisterEvent("PLAYER_ENTERING_WORLD")
	healthBar:RegisterEvent("UNIT_HEALTH")
	healthBar:RegisterEvent("UNIT_MAXHEALTH")
	healthBar:RegisterEvent("GROUP_ROSTER_UPDATE")

	-- creates HP text
	local healthText = healthBar:CreateFontString()
	healthText:SetPoint("CENTER", healthBar, "LEFT", 20, 0)
	healthText:SetJustifyH("RIGHT")
	healthText:SetTextColor( 1, 1, 1, .9)
	healthText:SetFont(barFont, healthFontSize, fontStyle)
		if(showHealthText == true) then
			healthText:Show() 
		else
			healthText:Hide()
		end

	-- unit name text
	local nameText = healthBar:CreateFontString()
	nameText:SetPoint("RIGHT", healthBar, "RIGHT", 40, 0)
	nameText:SetJustifyH("LEFT")
	nameText:SetTextColor( 1, 1, 1, 1)
	nameText:SetFont(barFont, nameFontSize, fontStyle)
	nameText:SetText(v)
		if(showNameText == true) then
			nameText:Show()
		else
			nameText:Hide()
		end

	-- updates HP bars
	healthBar:SetScript("OnEvent", 
		function(f, e, ...)
		f:SetMinMaxValues(0, UnitHealthMax(v))
		f:SetValue(UnitHealth(v))
		healthText:SetFormattedText("%s", sn(UnitHealth(v)))
		GetNumGroupMembers()
			if(UnitExists(v)) then 
				f:Show()
				_, class = UnitClass(v)
				c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
				healthBar:SetStatusBarColor(c.r, c.g, c.b)
			else
				f:Hide()
			end
	end)

	healthBar:SetScript("OnUpdate", rangeCheck) -- possible fix to range check not working

	-- creates then hides HP bar frame that actually receives the click event when clicking a party member's HP bar
	if (useTargetFunction == true) then
		local healthBarButton = CreateFrame("Button", "myhealthBarButton", healthBar, "SecureActionButtonTemplate"); 
		healthBarButton:SetAttribute("type", "target"); 
		healthBarButton:SetAttribute("target", "unit");
		healthBarButton:SetAttribute("unit", v);
		healthBarButton:SetAlpha(0);  -- set to 1 for debug
		healthBarButton:SetWidth(barWidth); 
		healthBarButton:SetHeight(barHeight); 
		healthBarButton:SetAllPoints(healthBar)
	end

	-- creates power bar for each member
	local powerBar = CreateFrame("StatusBar")
	powerBar:SetWidth(powerBarWidth)
	powerBar:SetHeight(powerBarHeight)
	powerBar:SetPoint("BOTTOM", healthBar, "BOTTOM", 0, -3)
	powerBar:SetOrientation(fillOrientation)
	powerBar:SetStatusBarTexture(barTexture)
	powerBar:SetBackdrop({
			bgFile=barTexture, 
			insets={left=barBorder, right=barBorder, top=barBorder, bottom=barBorder}});
	powerBar:SetBackdropColor(0, 0, 0, 1)
	powerBar:SetRotatesTexture(false)

	-- sets up events for updating power bar frames
	powerBar:RegisterEvent("ADDON_LOADED")
	powerBar:RegisterEvent("PLAYER_ENTERING_WORLD")
	powerBar:RegisterEvent("UNIT_DISPLAYPOWER")
	powerBar:RegisterEvent("UNIT_POWER_UPDATE")
	powerBar:RegisterEvent("UNIT_MAXPOWER")
	powerBar:RegisterEvent("GROUP_ROSTER_UPDATE")

	-- creates power bar text
	local powerText = powerBar:CreateFontString()
	powerText:SetPoint("CENTER", powerBar, "RIGHT", -20, 0)
	powerText:SetJustifyH("RIGHT")
	powerText:SetTextColor( 1, 1, 1, .9)
	powerText:SetFont(barFont, powerFontSize, fontStyle)
		if(showPowerText == true) then
			powerText:Show() 
			else
			powerText:Hide()
		end

	-- updates power bar frames
	powerBar:SetScript("OnEvent",
		function(f, e, ...)
		local col = PowerBarColor[UnitPowerType(v)]      
		f:SetStatusBarColor(col.r, col.g, col.b, .9)
		f:SetMinMaxValues(0, UnitPowerMax(v))
		f:SetValue(UnitPower(v))
		powerText:SetFormattedText("%s", sn(UnitPower(v)), sn(UnitPowerMax(v)))
			if(UnitExists(v)) then 
				f:Show()
			else
				f:Hide()
			end
	end)

	-- creates then hides power bar frame that actually receives the click event when clicking a party member's power bar
	if (useTargetFunction == true) then
		local powerBarButton = CreateFrame("Button", "mypowerBarButton", powerBar, "SecureActionButtonTemplate"); 
		powerBarButton:SetAttribute("type", "target"); 
		powerBarButton:SetAttribute("target", "unit");
		powerBarButton:SetAttribute("unit", v);
		powerBarButton:SetAlpha(0);  -- set to 1 for debug
		powerBarButton:SetWidth(powerBarWidth); 
		powerBarButton:SetHeight(powerBarHeight); 
		powerBarButton:SetAllPoints(powerBar)
	end

	-- range checking function
	updateInterval = .25
	local timer = 0
	function rangeCheck(self, elapsed)
		timer = timer + elapsed 	
		if (timer > updateInterval) then
				if UnitInRange(v) then
					--print(v, " is in range")
					healthBar:SetAlpha(inRangeAlpha)
					powerBar:SetAlpha(inRangeAlpha)
				elseif not UnitInRange(v) then
					healthBar:SetAlpha(outRangeAlpha)
					powerBar:SetAlpha(outRangeAlpha)
					--print(v, " is NOT in range")
				end
			timer = 0
		end
	end
end
