-- spells.xml entry
--<instant group="attack" spellid="999" name="Frigo" words="frigo" level="0" mana="0" premium="0" range="3" casterTargetOrDirection="0" cooldown="0" groupcooldown="0" needlearn="0" script="attack/frigo.lua">
--<vocation name="Sorcerer" />
--<vocation name="Druid" />
--<vocation name="Master Sorcerer" />
--<vocation name="Elder Druid" />
--</instant>

-- Defines the patter for the cast spell
local AREA_DIAMOND = {
	{0, 0, 0, 1, 0, 0, 0},
	{0, 0, 1, 0, 1, 0, 0},
	{0, 1, 0, 1, 0, 1, 0},
	{1, 0, 1, 3, 1, 0, 1},
	{0, 1, 0, 1, 0, 1, 0},
	{0, 0, 1, 0, 1, 0, 0},
	{0, 0, 0, 1, 0, 0, 0}
}

-- Defines the range for the initial spawn time for the effects
local spawnTimeRangeMin = 0
local spawnTimeRangeMax = 500

-- Defines the cycle length and count for the small tornados
local smallTornadoCycleTime = 1000
local smallTornadoCycleCount = 3

-- Defines the cycle length and count for the big tornados
local bigTornadoCycleTime = 750
local bigTornadoCycleCount = 4

-- Defines the combat variable and area
local combat = Combat()
combat:setArea(createCombatArea(AREA_DIAMOND))

function onCastSpell(creature, variant, isHotkey)
	return combat:execute(creature, variant)
end

-- Recursive function that spawns repeating tornados
function  spawnTornado(position, times, eventDelay)
	-- Creates the tornado effect at the specified position
	position:sendMagicEffect(CONST_ME_ICETORNADO)

	-- Repeats if its hasnt finished
	if(times > 0) then
		times = times - 1
		addEvent(spawnTornado, eventDelay, position, times, eventDelay)
	end
end

-- Function that occurs on each tile in the spell's range
function onTargetTile(creature, position)
	-- Determines the tiles position relative to the player
	-- Smaller tornados get spawned on odd spots
	local oddSpace = position.x - creature:getPosition().x

	-- Sets the initial spawn time for the tornados
	local timeToSpawn = math.random(spawnTimeRangeMin, spawnTimeRangeMax)

	-- Creates an event that spawns a tornado with parameters depending on the tile's positon
	if(oddSpace % 2 == 0) then
		addEvent(spawnTornado, timeToSpawn, position, bigTornadoCycleCount, bigTornadoCycleTime)
	else
		addEvent(spawnTornado, timeToSpawn, position, smallTornadoCycleCount, smallTornadoCycleTime)
	end
end

-- Creates the combat callback to be called for each tile
combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")