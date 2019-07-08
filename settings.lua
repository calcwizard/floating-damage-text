
data:extend({ 	

	-- runtime global
   {
		type = "string-setting",
		name = "floating-damage-string-format",
		setting_type = "runtime-global",
		default_value = "%.4g",
		order = "d[alpha]-[format]",
	},
	{
		type = "string-setting",
		name = "floating-integer-rounding",
		setting_type = "runtime-global",
		default_value = "nearest",
		allowed_values = { "floor", "nearest", "ceiling" },
		order = "d[alpha]-[rounding]",		
	},
	{
		type = "string-setting",
		name = "floating-ally-damage-color",
		setting_type = "runtime-global",
		default_value = "255,127,0",
		order = "d[color]-[ally]",
	},
	{
		type = "string-setting",
		name = "floating-enemy-damage-color",
		setting_type = "runtime-global",
		default_value = "200,0,0",
		order = "d[color]-[enemy]",
	},
	{
		type = "string-setting",
		name = "floating-neutral-damage-color",
		setting_type = "runtime-global",
		default_value = "200,200,200",
		order = "d[color]-[neutral]",
	},
	

})

