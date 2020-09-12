--- Customize anything below to your liking. ---
fillOrientation = "HORIZONTAL"  -- which direction the bars fill; combine with proper bar dimensions for best effect
useClassColor = true
useTargetFunction = true  -- enable/disable clicking on the frame to target the associated player
showNameText = true
showPowerText = true
showHealthText = true

barTexture = "Interface\\AddOns\\broBars\\media\\raidbar.tga"
barFont = "Interface\\AddOns\\broBars\\media\\Coolvetica.ttf"
healthFontSize = 8
powerFontSize = 6
nameFontSize = 8
fontStyle = "THINOUTLINE"   -- options:  "OUTLINE",  "THICKOUTLINE", or "" (that's double quotes, no space for no outline)

inRangeAlpha = 1
outRangeAlpha = .2

barWidth = 50
barHeight = 15
powerBarWidth = 50
powerBarHeight = 2
barBorder = -1

--- Starting position for bars
hPosition = -340
vPosition = -85
barOffset = -25

--- Your own character's name goes here
ownChar = "Lumzy"  --- if you don't want your own character included in the bars, just enter nothing here between the quotes, as in ""

--- Populate the following table with the list of all characters you want to have bars shown for
characterList = {
	"Asemic",
	"Zarisel",
	ownChar,  --- Comment this line out if you don't want your character shown
}
