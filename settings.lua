
data:extend({ 	

	-- runtime global
   {
		type = "string-setting",
		name = "floating-damage-string-format",
		setting_type = "runtime-global",
		default_value = "%.4g",
		order = "d[alphabet]-[format]",
		per_user = false,
	},
	{
		type = "string-setting",
		name = "floating-ally-damage-color",
		setting_type = "runtime-global",
		default_value = "255,127,0",
		order = "d[color]-[ally]",
		per_user = false,
	},
	{
		type = "string-setting",
		name = "floating-enemy-damage-color",
		setting_type = "runtime-global",
		default_value = "200,0,0",
		order = "d[color]-[enemy]",
		per_user = false,
	},
	{
		type = "string-setting",
		name = "floating-neutral-damage-color",
		setting_type = "runtime-global",
		default_value = "200,200,200",
		order = "d[color]-[neutral]",
		per_user = false,
	},
	--[[
	{
		type = "string-setting",
		name = "floating-healing-color",
		setting_type = "runtime-global",
		default_value = "0,255,0",
		order = "h[Color]",
		per_user = false,
	},
	]]

})

