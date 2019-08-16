
data:extend({
 {
    type = "flying-text",
    name = "flying-damage-text",
    flags = {"not-on-map", "placeable-off-grid"},
    time_to_live = settings.startup["floating-damage-lifetime"].value,
    speed = settings.startup["floating-damage-velocity"].value / 60,
  },
  {
    type = "flying-text",
    name = "flying-healing-text",
    flags = {"not-on-map", "placeable-off-grid"},
    time_to_live = settings.startup["floating-damage-lifetime"].value,
    speed = settings.startup["floating-damage-velocity"].value / 60,
  },

})