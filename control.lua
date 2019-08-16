require("lualib/utils")
require("util")

local config
local rounding_value

-- converts the string from the settings to a Type/Color structure
-- returns {r, g, b} if valid or nil if invalid
function stringToColors (colorString)
  local valid = true
  _, _, r_str, g_str, b_str = string.find(colorString, "%s*(%d+%.?%d*)%s*,%s*(%d+%.?%d*)%s*,%s*(%d+%.?%d*)%s*")
  local num = {r = tonumber(r_str), g = tonumber(g_str), b = tonumber(b_str)}
  if not num or not next(num) then 
    valid = false
  end

  --game.print(num.r .. " " .. num.g .. " " .. num.b)
  for _, thisNum in pairs(num) do
      if thisNum == nil or thisNum > 255 or thisNum < 0 then
        valid = false
      end
  end
  if valid then 
    return num
  else
    return nil
  end
end

-- returns num rounded to the nearest multiple of scale with a minimum value of scale
function round_or_floor(num, scale)
  if num then
    return (num < scale and scale or math.floor(num / scale + 0.5) * scale)
  end
end




-- mirrors the mod's settings to the global table
function globalize_settings()
  global.settings = {
      ["floating-damage-string-format"] = settings.global["floating-damage-string-format"].value,
      ["floating-number-rounding"] = settings.global["floating-number-rounding"].value,
      ["floating-ally-damage-color"] = stringToColors(settings.global["floating-ally-damage-color"].value) or {r = 255, g = 127, b = 0}, --settings.global["floating-damage-string-format"].value
      ["floating-enemy-damage-color"] = stringToColors(settings.global["floating-enemy-damage-color"].value) or {r = 200, g = 0, b = 0}, --settings.global["floating-damage-string-format"].value
      ["floating-neutral-damage-color"] = stringToColors(settings.global["floating-neutral-damage-color"].value) or {r = 200, g = 200, b = 200}, --settings.global["floating-damage-string-format"].value
      ["floating-healing-string-format"] = settings.global["floating-healing-string-format"].value,
      ["floating-healing-color"] = stringToColors(settings.global["floating-healing-color"].value) or {r = 0, g = 255, b = 0},
  }
  localize_settings()
end

function localize_settings()
  --config = global.settings
  config = util.table.deepcopy(global.settings)
  if config then
    rounding_value = 10^(-(config["floating-number-rounding"] or 0))
  end
end

function display_damage_text(event)
    local damaged_entity = event.entity
    local entity_position = damaged_entity.position
    --local damage_amount = event.final_damage_amount + (string.find(config["floating-damage-string-format"], "%%%S*[iduoxX]") and ROUNDING[config["floating-integer-rounding"]] or 0)
    local damage_amount = round_or_floor(event.final_damage_amount, rounding_value)

    local text_color = config["floating-neutral-damage-color"]
    if damaged_entity.type == "character" or damaged_entity.type == "car" then
      text_color = config["floating-ally-damage-color"]
    elseif damaged_entity.type == "unit" or  damaged_entity.type == "unit-spawner" or (damaged_entity.type == "turret" and string.find(damaged_entity.name, "worm")) then
      text_color = config["floating-enemy-damage-color"]
    end

    entity_position.y = entity_position.y - 2 + math.random()
    entity_position.x = entity_position.x - 1 + math.random()
    damaged_entity.surface.create_entity{name="flying-damage-text", position=entity_position, text=string.format(config["floating-damage-string-format"],damage_amount,event.damage_type.name), color=text_color}
end

function display_healing_text(entity, deltaHealth)
    local entityPosition = entity.position
    local healingAmount = round_or_floor(deltaHealth, rounding_value)

    entityPosition.y = entityPosition.y - 2 + math.random()
    entityPosition.x = entityPosition.x - 1 + math.random()
    entity.surface.create_entity{name="flying-healing-text", position=entityPosition, text=string.format(config["floating-healing-string-format"],healingAmount), color=config["floating-healing-color"]}
end

function iterate_damage_table(event)
  for entityNum,oldHealth in pairs(global.entity_health) do
    local entity = global.entities[entityNum]
    if entity.valid then
      if entity.health > oldHealth then
        display_healing_text(entity, entity.health-oldHealth)
        global.entity_health[entityNum] = entity.health
      elseif entity.health < oldHealth then
        global.entity_health[entityNum] = entity.health
      elseif entity.get_health_ratio() == 1 then
        global.entity_health[entityNum] = nil
        game.print("entity removed for having full health")
      end
    else
      global.entity_health[entityNum] = nil
      game.print("entity removed for being invalid")
    end
  end
end




-- event handlers

script.on_init(function(event) 
  globalize_settings() 
  global.entity_health = {}
  global.entities = {}
end)
script.on_load(function(event) localize_settings() end)

script.on_configuration_changed(function(event)
  local changed = event.mod_changes and event.mod_changes["floating-damage-text"]

  if changed then
    if is_version_older_than(changed.old_version, "0.17.4") then
      if settings.global["floating-damage-string-format"].value == "%.4g" then
        settings.global["floating-damage-string-format"] = {value = "%s"}
      end
      game.print({"", "[", {"mod-name.floating-damage-text"}, "] Default mod settings have been changed."})
    end
    if is_version_older_than(changed.old_version, "0.17.5") then
      global.entities = {}
      global.entity_health = {}
    end

    globalize_settings()
  end
end)

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
  if global.settings[event.setting] then
    if string.find(event.setting, "color") then
      local newColor = stringToColors(settings.global[event.setting].value)
      if newColor then
        global.settings[event.setting] = newColor
      else
        if event.player_index then
          game.get_player(event.player_index).print({"", "[", {"mod-name.floating-damage-text"}, "] Invalid color string.  Setting wasn't changed."})
        end
        local colorString = "" .. global.settings[event.setting].r .. "," .. global.settings[event.setting].g .. "," .. global.settings[event.setting].b
        settings.global[event.setting] = {value = colorString}
      end
    else
      global.settings[event.setting] = settings.global[event.setting].value
    end
    localize_settings()
  end
end)

script.on_event(defines.events.on_entity_damaged, function(event)
  if not config then
    game.print({"", "[", {"mod-name.floating-damage-text"}, "] The local settings table wasn't initialized.  Please report this to the mod author."})
    script.on_event(defines.events.on_entity_damaged, nil)
    return
  end
  if(event.final_damage_amount > 0) then 
    display_damage_text(event) 
    if event.entity.health > 0 and event.entity.unit_number then
      global.entities[event.entity.unit_number] = event.entity
      global.entity_health[event.entity.unit_number] = event.entity.health
    end
  end
end)

script.on_nth_tick(settings.global["floating-healing-interval"].value, function(event) iterate_damage_table(event) end)








function addToSet(set, key)
    set[key] = true
end

function removeFromSet(set, key)
    set[key] = nil
end

function setContains(set, key)
    return set[key] ~= nil
end