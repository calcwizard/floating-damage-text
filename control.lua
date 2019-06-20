
function round(x)
  return x + 0.005 - (x + 0.005) % 0.01
end


script.on_event(defines.events.on_entity_damaged, function(event)
  if(event.final_damage_amount > 0) then
    local damage_text = "-" .. round(event.final_damage_amount)
    local damaged_entity = event.entity
    local entity_position = damaged_entity.position

    local text_color = {200,200,200}
    if damaged_entity.force.name == "enemy" or damaged_entity.type == "character" then
      text_color = {255,0,0}
    end

    entity_position.y = entity_position.y - 2 + math.random()
    entity_position.x = entity_position.x - 1 + math.random()
    damaged_entity.surface.create_entity{name="flying-text", position=entity_position, text=damage_text, color=text_color}
  end
end)
