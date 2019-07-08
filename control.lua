require("util")

local config
local ROUNDING = {["floor"] = 0, ["nearest"] = 0.5, ["ceiling"] = 0.99999}
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
    game.print({"", "[", {"mod-name.floating-damage-text"}, "] Invalid color string.  Setting wasn't changed."})
    return nil
  end
end


-- mirrors the mod's settings to the global table
function globalizeSettings()
  global.settings = {
      ["floating-damage-string-format"] = settings.global["floating-damage-string-format"].value,
      ["floating-integer-rounding"] = settings.global["floating-integer-rounding"].value,
      ["floating-ally-damage-color"] = stringToColors(settings.global["floating-ally-damage-color"].value) or {r = 255, g = 127, b = 0}, --settings.global["floating-damage-string-format"].value
      ["floating-enemy-damage-color"] = stringToColors(settings.global["floating-enemy-damage-color"].value) or {r = 200, g = 0, b = 0}, --settings.global["floating-damage-string-format"].value
      ["floating-neutral-damage-color"] = stringToColors(settings.global["floating-neutral-damage-color"].value) or {r = 200, g = 200, b = 200}, --settings.global["floating-damage-string-format"].value
      --["floating-healing-color"] = stringToColors(settings.global["floating-healing-color"].value) or {r = 0, g = 255, b = 0},
  }
  localizeSettings()
end

function localizeSettings()
  --config = global.settings
  config = util.table.deepcopy(global.settings)
  rounding_value = (string.find(config["floating-damage-string-format"], "%%%S*[iduoxX]") and ROUNDING[config["floating-integer-rounding"]] or 0)
end

script.on_event(defines.events.on_entity_damaged, function(event)
  if not config then
    game.print({"", "[", {"mod-name.floating-damage-text"}, "] The local settings table wasn't initialized.  Please report this to the mod author."})
    script.on_event(defines.events.on_entity_damaged, nil)
    return
  end
  if(event.final_damage_amount > 0) then
    local damaged_entity = event.entity
    local entity_position = damaged_entity.position
    --local damage_amount = event.final_damage_amount + (string.find(config["floating-damage-string-format"], "%%%S*[iduoxX]") and ROUNDING[config["floating-integer-rounding"]] or 0)
    local damage_amount = event.final_damage_amount + rounding_value

    local text_color = config["floating-neutral-damage-color"]
    if damaged_entity.type == "character" or damaged_entity.type == "car" then
      text_color = config["floating-ally-damage-color"]
    elseif damaged_entity.type == "unit" or  damaged_entity.type == "unit-spawner" or (damaged_entity.type == "turret" and string.find(damaged_entity.name, "worm")) then
      text_color = config["floating-enemy-damage-color"]
    end

    entity_position.y = entity_position.y - 2 + math.random()
    entity_position.x = entity_position.x - 1 + math.random()
    damaged_entity.surface.create_entity{name="flying-text", position=entity_position, text=string.format(config["floating-damage-string-format"],damage_amount,event.damage_type.name), color=text_color}
  end
end)


-- event handlers

script.on_init(function(event) globalizeSettings() end)
script.on_load(function(event) localizeSettings() end)

script.on_configuration_changed(function(event)
  local changed = event.mod_changes and event.mod_changes["floating-damage-text"]

  if changed then
    globalizeSettings()
  end
end)

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
  if global.settings[event.setting] then
    if string.find(event.setting, "color") then
      local newColor = stringToColors(settings.global[event.setting].value)
      if newColor then
        global.settings[event.setting] = newColor
      else
        local colorString = "" .. global.settings[event.setting].r .. "," .. global.settings[event.setting].g .. "," .. global.settings[event.setting].b
        settings.global[event.setting] = {value = colorString}
      end
    else
      global.settings[event.setting] = settings.global[event.setting].value
    end
    localizeSettings()
  end
end)